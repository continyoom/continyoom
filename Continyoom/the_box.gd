extends CSGBox

var history
var latest_state

var initial_transform
var velocity = Vector3(0, 0, 0)
var rotation_velocity = 0
var falling_velocity = 0

var timescale = KEY_TIMESCALE

const MOVE_SPEED = 200
const MOVE_FRICTION = 20
const ROTATION_SPEED = 60
const ROTATION_FRICTION = 30
const HEIGHT_ABOVE_GROUND = .125
const SEARCH_LOW = .5
const SEARCH_HIGH = .5
const GRAVITY = -20
const REVERSE_SPEED = 1
const KEY_TIMESCALE = 1
const MAX_TIMESCALE = 2

func _ready():
	initial_transform = get_global_transform()
	reset()
	pass

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_R):
		reset()
	
	if Input.is_key_pressed(KEY_S):
		timescale = -KEY_TIMESCALE
	elif Input.is_key_pressed(KEY_W):
		timescale = MAX_TIMESCALE
	else:
		timescale = KEY_TIMESCALE
	
	delta *= timescale
	
	if timescale < 0:
		step_back(delta * -1)
	else:
		stash_state(delta)
		
		var zvels = 1
		var xvels = 1
		var rvels = 1
		if abs(velocity.z) > 1:
			zvels = abs(velocity.z)
		if abs(velocity.x) > 1:
			xvels = abs(velocity.x)
		if abs(rotation_velocity) > 1:
			rvels = abs(rotation_velocity)
		if Input.is_action_pressed("ui_up"):
			velocity.z -= MOVE_SPEED * delta / zvels
		if Input.is_action_pressed("ui_down"):
			velocity.z += MOVE_SPEED * delta / zvels
		if Input.is_action_pressed("ui_left"):
			velocity.x -= MOVE_SPEED * delta / xvels
		if Input.is_action_pressed("ui_right"):
			velocity.x += MOVE_SPEED * delta / xvels
		if Input.is_action_pressed("ui_page_up"):
			velocity.y += MOVE_SPEED * delta
		if Input.is_action_pressed("ui_page_down"):
			velocity.y -= MOVE_SPEED * delta
		if Input.is_key_pressed(KEY_A):
			rotation_velocity += ROTATION_SPEED * delta / rvels
		if Input.is_key_pressed(KEY_D):
			rotation_velocity -= ROTATION_SPEED * delta / rvels
		velocity.x -= MOVE_FRICTION * sign(velocity.x) * delta
		velocity.z -= MOVE_FRICTION * sign(velocity.z) * delta
		rotation_velocity -= ROTATION_FRICTION * sign(rotation_velocity) * delta
		if abs(velocity.x) < abs(MOVE_FRICTION * sign(velocity.x) * delta) * 1.5:
			velocity.x = 0
		if abs(velocity.z) < abs(MOVE_FRICTION * sign(velocity.z) * delta) * 1.5:
			velocity.z = 0
		if abs(rotation_velocity) < abs(ROTATION_FRICTION * sign(rotation_velocity) * delta) * .5:
			rotation_velocity = 0
		translate(velocity * delta)
		rotate_object_local(Vector3(0, 1, 0), rotation_velocity * delta)
	
	var gt = get_global_transform()
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(gt.basis.y * SEARCH_LOW + gt.origin, gt.basis.y * -SEARCH_HIGH + gt.origin)
	
	if hit:
		set_as_toplevel(true)
		var plane = Plane(gt.origin + hit.normal, gt.origin + gt.basis.y, gt.origin)
		var rotation_angle = gt.basis.y.angle_to(hit.normal)
		if rotation_angle != 0 && plane.normal != Vector3(0, 0, 0):
			rotate(plane.normal, rotation_angle)
		set_translation(hit.position + get_global_transform().basis.y * HEIGHT_ABOVE_GROUND)
		set_as_toplevel(false)
		falling_velocity = 0
	else:
		falling_velocity += GRAVITY * delta
		translate(Vector3(0, falling_velocity * delta, 0))

func _process(delta):
	pass

func reset():
	set_global_transform(initial_transform)
	velocity = Vector3(0, 0, 0)
	rotation_velocity = 0
	falling_velocity = 0
	history = Array()

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
	state["velocity"] = velocity
	state["rotation_velocity"] = rotation_velocity
	state["falling_velocity"] = falling_velocity
	state["delta"] = delta
	state["remaining_delta"] = delta
	return state

func set_state_from_dictionary(var state):
	set_global_transform(state.transform)
	velocity = state.velocity
	rotation_velocity = state.rotation_velocity
	falling_velocity = state.falling_velocity

func interpolate_states(var later_state, var earlier_state, var delta):
	var state = Dictionary()
	var lerp_amount = 1 - delta / earlier_state.delta

	state["transform"] = lerp_transform(earlier_state.transform, later_state.transform, lerp_amount)
	state["velocity"] = lerp(earlier_state.velocity, later_state.velocity, lerp_amount)
	state["rotation_velocity"] = lerp(earlier_state.rotation_velocity, later_state.rotation_velocity, lerp_amount)
	state["falling_velocity"] = lerp(earlier_state.falling_velocity, later_state.falling_velocity, lerp_amount)
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
