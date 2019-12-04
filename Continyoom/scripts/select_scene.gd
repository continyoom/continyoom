extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var view = get_viewport_rect().size
	$label.rect_position = Vector2(view.x / 2 - $label.rect_size.x / 2, 60)
	$r_road.rect_position = Vector2(view.x / 2 - $r_road.rect_size.x / 2, 290)
	$legal_track.rect_position = Vector2(view.x / 2 - $legal_track.rect_size.x / 2, 400)

#rainbow road
func _on_r_road_pressed():
	get_tree().change_scene("scenes/play_ndsrr.tscn")

#legal track
func _on_legal_track_pressed():
	get_tree().change_scene("scenes/play_legalTrack1.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
