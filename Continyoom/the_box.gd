extends CSGBox

var initial_transform
var velocity = Vector3(0, 0, 0)
var rotation_velocity = 0
var falling_velocity = 0
const MOVE_SPEED = 1
const MOVE_FRICTION = .9
const ROTATION_SPEED = .005
const ROTATION_FRICTION = .85
const HEIGHT_ABOVE_GROUND = .125
const SEARCH_LOW = .5
const SEARCH_HIGH = .5
const GRAVITY = -.25

func _ready():
	initial_transform = get_global_transform()
	pass

func _physics_process(delta):
	if Input.is_key_pressed(KEY_R):
		set_global_transform(initial_transform)
		velocity = Vector3(0, 0, 0)
		rotation_velocity = 0
		falling_velocity = 0
	if Input.is_action_pressed("ui_up"):
		velocity.z -= MOVE_SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.z += MOVE_SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= MOVE_SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += MOVE_SPEED
	if Input.is_action_pressed("ui_page_up"):
		velocity.y += MOVE_SPEED
	if Input.is_action_pressed("ui_page_down"):
		velocity.y -= MOVE_SPEED
	if Input.is_key_pressed(KEY_A):
		rotation_velocity += ROTATION_SPEED
	if Input.is_key_pressed(KEY_D):
		rotation_velocity -= ROTATION_SPEED
	
	velocity *= MOVE_FRICTION
	rotation_velocity *= ROTATION_FRICTION
	translate(velocity * delta)
	rotate_object_local(Vector3(0, 1, 0), rotation_velocity)
	
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
		translate(Vector3(0, falling_velocity, 0))

func _process(delta):
	pass
