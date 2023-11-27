extends Interactable

@onready var curtain_cloth1 = get_node("curtain_support/curtain_cloth1")
@onready var curtain_cloth2 = get_node("curtain_support/curtain_cloth2")

@onready var animation_player = $curtainAnimationPlayer

var is_open := false

func action_use():
	if is_open:
		close()
	else:
		open()

func close():
	curtain_cloth1.scale.z = 1
	curtain_cloth2.scale.z = 1
	is_open = false
	type = "Open curtains"

func open():
	curtain_cloth1.scale.z = 0.24
	curtain_cloth2.scale.z = 0.24
	is_open = true
	type = "Close curtains"
