extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	get_tree().change_scene("menu_scene.tscn")

#signal from quit button
func _on_quit_pressed():
	get_tree().quit()

