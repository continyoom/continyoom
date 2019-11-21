extends AnimationPlayer

func _ready():
	var the_box = get_node("../../the_box")
#	print(get_parent().get_parent().get_parent().get_children())
	if (the_box != null):
		the_box.connect("timescale_update", self, "_on_timescale_update")

func _on_timescale_update(var new_timescale):
	set_speed_scale(new_timescale * 4)