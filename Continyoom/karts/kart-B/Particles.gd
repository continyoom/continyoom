extends Particles

var init = 6

func _ready():
	var the_box = get_node("../../../the_box")
	if (the_box != null):
		the_box.connect("timescale_update", self, "_on_timescale_update")
		the_box.connect("begin_drift", self, "_on_begin_drift")
		the_box.connect("end_drift", self, "_on_end_drift")
	emitting = true

func _process(delta):
	if (init >= 1):
		emitting = true
		init -= 1
	if (init == 1):
		emitting = false
		init = 0

func _on_timescale_update(var new_timescale):
	set_speed_scale(abs(new_timescale * 1))

func _on_begin_drift():
	emitting = true

func _on_end_drift():
	emitting = false
