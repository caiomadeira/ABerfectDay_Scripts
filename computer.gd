extends Interactable


func _ready():
	GlobalScript.computer_is_on = false

func _input(_event):
	if Input.is_action_just_pressed("f - leave") and GlobalScript.computer_is_on:
		logout()

func action_use():
	GlobalScript.is_mov_enable = false
	GlobalScript.computer_is_on = true
	if GlobalScript.computer_is_on:
		login()
	else:
		logout()
	
func login():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	GlobalScript.computer_is_on = true

func logout():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalScript.computer_is_on = false
	GlobalScript.is_mov_enable = true
