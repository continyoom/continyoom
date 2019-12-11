extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if(!Input.get_connected_joypads().empty()):
		$r_road.grab_focus()


func _physics_process(delta):
	var view = get_viewport_rect().size
	$label.rect_position = Vector2(view.x / 2 - $label.rect_size.x / 2, 60)
	$r_road.rect_position = Vector2(view.x / 2 - $r_road.rect_size.x / 2, 290)
	$legal_track.rect_position = Vector2(view.x / 2 - $legal_track.rect_size.x / 2, 400)
	$back.rect_position = Vector2(16, view.y - (70 + 16))



func enter_game(path):
	get_tree().change_scene(path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#rainbow road
func _on_r_road_pressed():
	enter_game("scenes/play_ndsrr.tscn")

#legal track
func _on_legal_track_pressed():
	enter_game("scenes/play_legalTrack1.tscn")

#back
func _on_back_pressed():
	get_tree().change_scene("scenes/menu_scene.tscn")
