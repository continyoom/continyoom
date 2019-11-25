extends Control

var view

func _ready():
	view = get_viewport_rect().size

func _physics_process(delta):
	view = get_viewport_rect().size
	$resume.rect_position = Vector2(view.x / 2 - $resume.rect_size.x / 2, view.y / 2 - 100)
	$menu.rect_position = Vector2(view.x / 2 - $menu.rect_size.x / 2, view.y / 2)
	$quit.rect_position = Vector2(view.x / 2 - $quit.rect_size.x / 2, view.y / 2 + 100)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		#de presses action, only important when action is triggered in code
		Input.action_release("pause")
		
		#show/hide when necessary
		if get_tree().paused:
			self.hide()
		if not get_tree().paused:
			self.show()
		
		#switch pause state
		get_tree().paused = not get_tree().paused

#signal from resume button
func _on_resume_pressed():
	Input.action_press("pause")

#signal from menu button
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("scenes/menu_scene.tscn")

#signal from quit button
func _on_quit_pressed():
	get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT and !get_tree().paused:
		Input.action_press("pause")
