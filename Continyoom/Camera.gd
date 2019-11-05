extends Camera

var current_position

func _ready():
	current_position = get_global_transform().origin

func _physics_process(delta):
	var the_box = get_parent().get_node("moving_box/the_box")
	var box_transform = the_box.get_global_transform()
	var box_y_axis = box_transform.basis.y
	var box_z_axis = box_transform.basis.z
	var box_position = box_transform.origin
	
	var target_position = box_position + box_y_axis * 1 - box_z_axis * -2
	
	var orientation = get_global_transform().basis
	look_at(box_position, box_y_axis)
	var new_orientation = get_global_transform().basis
	
	var rotation_lerp_amount = 10
	var updated_orientation_x = orientation.x * (1 - rotation_lerp_amount * delta) + new_orientation.x * rotation_lerp_amount * delta
	var updated_orientation_y = orientation.y * (1 - rotation_lerp_amount * delta) + new_orientation.y * rotation_lerp_amount * delta
	var updated_orientation_z = orientation.z * (1 - rotation_lerp_amount * delta) + new_orientation.z * rotation_lerp_amount * delta
	set_global_transform(Transform(updated_orientation_x, updated_orientation_y, updated_orientation_z, get_global_transform().origin))
	
	var translation_lerp_amount = 4
	current_position = current_position * (1 - translation_lerp_amount * delta) + target_position * translation_lerp_amount * delta
	set_translation(current_position)

#func _process(delta):
#	pass
