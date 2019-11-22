extends Spatial

var timescale = 1
const TWEAK = -.125


func _ready():
	var the_box = get_node("../the_box")
	if (the_box != null):
		the_box.connect("timescale_update", self, "_on_timescale_update")

func _physics_process(delta):
	translate_object_local(Vector3(0, -TWEAK, 0))
	set_as_toplevel(true)
	var tf = get_node("../the_box").get_global_transform()
	set_translation(tf.origin)
	var gt = get_global_transform()
	transform = gt.interpolate_with(tf, .2 * abs(timescale))
	transform = transform.orthonormalized()
	translate_object_local(Vector3(0, TWEAK, 0))

func _on_timescale_update(var new_timescale):
	timescale = new_timescale