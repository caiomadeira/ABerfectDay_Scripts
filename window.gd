extends Interactable

@onready var animation_player = $AnimationPlayer
var is_open := false
var can_interact := true

func action_use():
	if can_interact:
		if is_open:
			close()
		else:
			open()

func close():
	animation_player.play("window_close")
	can_interact = false
	is_open = false
	type = "Open Window"

func open():
	animation_player.play("window_open")
	can_interact = false
	is_open = true
	type = "Close Window"

func _on_animation_player_animation_finished(_anim_name):
	can_interact = true
