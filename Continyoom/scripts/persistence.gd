extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = {'sound': false}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mute"):
		mute()
		
func mute():
	state['sound'] = not state['sound']
