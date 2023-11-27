extends Control

var paused: bool = false

func _ready():
	visible = false
		
func _process(_delta):
	paused = !paused
	if Input.is_action_just_pressed("esc"):
		if paused:
			get_tree().set_pause(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().set_pause(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_button_pressed():
	get_tree().quit()
