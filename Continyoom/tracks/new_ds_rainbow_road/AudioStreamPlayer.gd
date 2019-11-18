extends AudioStreamPlayer

var mute
const MUTE_SPEED = 4
var complete_mute = false

func _ready():
	yield(get_tree().create_timer(.1), "timeout")  # no clue why this works
	mute = 0.2  # makes start slightly less punchy
	playing = true

func _physics_process(delta):
	if (mute == null):
		return
	if (get_tree().paused == true):
		mute += delta * MUTE_SPEED
		if (mute > 1):
			mute = 1
	else:
		mute -= delta * MUTE_SPEED
		if (mute < 0):
			mute = 0
	update_mute()
	if (Input.is_action_just_pressed("mute")):
		complete_mute = !complete_mute
	complete_mute(complete_mute)

func update_mute():
	var effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("PauseEQ"), 0)
	effect.set_band_gain_db(3, -40 * mute)
	effect.set_band_gain_db(4, -40 * mute)
	effect.set_band_gain_db(5, -40 * mute)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -3 * mute)

func complete_mute(var mute):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)