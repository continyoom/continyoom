extends Camera

var history
var latest_state
var timescale

var current_position

func _ready():
	get_parent().get_node("moving_box/the_box").connect("timescale_update", self, "_on_timescale_update")
	current_position = get_global_transform().origin
	history = Array()
	timescale = 1
	latest_state = get_state_as_dictionary(timescale)

func _physics_process(delta):
	delta *= timescale
	
	# TODO: unbreak this when using timescale
	if (delta < 0):
		step_back(-delta)
	else:
		stash_state(delta)
		var the_box = get_parent().get_node("moving_box/the_box")
		
		if the_box.third_person:
			third_person_camera(delta, the_box)
		else:
			first_person_camera(delta, the_box)

func third_person_camera(delta, the_box):
	var box_transform = the_box.get_global_transform()
	var box_y_axis = box_transform.basis.y
	var box_z_axis = box_transform.basis.z
	var box_position = box_transform.origin
	
	var target_position = box_position + box_y_axis * .375 - box_z_axis * -.75
	
	var orientation = get_global_transform().basis
	look_at(box_position, box_y_axis)
	#rotate_z(.5)
	global_rotate(get_global_transform().basis.x, .2)
	var new_orientation = get_global_transform().basis
	
	var rotation_lerp_amount = 10
	var updated_orientation_x = orientation.x * (1 - rotation_lerp_amount * delta) + new_orientation.x * rotation_lerp_amount * delta
	var updated_orientation_y = orientation.y * (1 - rotation_lerp_amount * delta) + new_orientation.y * rotation_lerp_amount * delta
	var updated_orientation_z = orientation.z * (1 - rotation_lerp_amount * delta) + new_orientation.z * rotation_lerp_amount * delta
	set_global_transform(Transform(updated_orientation_x, updated_orientation_y, updated_orientation_z, get_global_transform().origin))
	
	var translation_lerp_amount = 6
	current_position = current_position * (1 - translation_lerp_amount * delta) + target_position * translation_lerp_amount * delta
	set_translation(current_position)

func first_person_camera(delta, the_box):
	var box_transform = the_box.get_global_transform()
	var box_y_axis = box_transform.basis.y
	var box_z_axis = box_transform.basis.z
	var box_position = box_transform.origin
	
	box_position.y+= 0.1
	
	#var target_position = box_position + box_y_axis * .375 - box_z_axis * -.75
	var target_position = box_position
	
	var orientation = get_global_transform().basis
	look_at(box_position, box_y_axis)
	#rotate_z(.5)
	global_rotate(get_global_transform().basis.x, .2)
	var new_orientation = get_global_transform().basis
	
	var rotation_lerp_amount = 10
	var updated_orientation_x = orientation.x * (1 - rotation_lerp_amount * delta) + new_orientation.x * rotation_lerp_amount * delta
	var updated_orientation_y = orientation.y * (1 - rotation_lerp_amount * delta) + new_orientation.y * rotation_lerp_amount * delta
	var updated_orientation_z = orientation.z * (1 - rotation_lerp_amount * delta) + new_orientation.z * rotation_lerp_amount * delta
	set_global_transform(Transform(updated_orientation_x, updated_orientation_y, updated_orientation_z, get_global_transform().origin))
	
	set_translation(box_position)

func stash_state(var delta):
	latest_state = get_state_as_dictionary(delta)
	history.push_back(latest_state)

func step_back(var delta):
	while history.size() > 0 and delta >= history.back().remaining_delta:
		latest_state = history.pop_back()
		delta -= latest_state.remaining_delta
	if history.size() == 0:
		return
	history.back().remaining_delta -= delta
	set_state_from_dictionary(interpolate_states(history.back(), latest_state, history.back().remaining_delta))

func get_state_as_dictionary(var delta):
	var state = Dictionary()
	state["transform"] = get_global_transform()
	state["delta"] = delta
	state["remaining_delta"] = delta
	return state

func set_state_from_dictionary(var state):
	set_global_transform(state.transform)
	current_position = state.transform.origin

func interpolate_states(var later_state, var earlier_state, var delta):
	var state = Dictionary()
	var lerp_amount = 1 - delta / earlier_state.delta
	state["transform"] = lerp_transform(earlier_state.transform, later_state.transform, lerp_amount)
	state["delta"] = null
	state["remaining_delta"] = null
	return state

func lerp_transform(var earlier_transform, var later_transform, var lerp_amount):
	var orientation = earlier_transform.basis
	var new_orientation = later_transform.basis
	var updated_orientation_x = orientation.x * (1 - lerp_amount) + new_orientation.x * lerp_amount
	var updated_orientation_y = orientation.y * (1 - lerp_amount) + new_orientation.y * lerp_amount
	var updated_orientation_z = orientation.z * (1 - lerp_amount) + new_orientation.z * lerp_amount
	var updated_origin = lerp(earlier_transform.origin, later_transform.origin, lerp_amount)
	return Transform(updated_orientation_x, updated_orientation_y, updated_orientation_z, updated_origin)

func _on_timescale_update(var new_timescale):
	timescale = new_timescale
