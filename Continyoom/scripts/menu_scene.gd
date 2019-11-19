extends Control

func _physics_process(delta):
	var view = get_viewport_rect().size
	$title.rect_position = Vector2(view.x / 2 - $title.rect_size.x / 2, 50)
	$wide_car.global_position = Vector2(view.x / 2, view.y / 2)
	var img_scale = max($wide_car.global_position.x / 250, $wide_car.global_position.y / 150)
	$wide_car.global_scale = Vector2(img_scale, img_scale)
	$play.rect_position = Vector2(view.x / 2 - $play.rect_size.x / 2, view.y - 150)

#play button
func _on_Button_pressed():
	#get_tree().change_scene("scenes/main_scene.tscn")
	#get_tree().change_scene("scenes/play_ndsrr.tscn")
	get_tree().change_scene("scenes/select_scene.tscn")
