extends Interactable

@onready var animation_player = $AnimationPlayer
var is_on: bool = false

func _ready():
	type = "Fan"

func action_use():
	if is_on:
		off()
	else:
		on()
	
func off():
	animation_player.play("off")
	is_on = false
	
func on():
	animation_player.play("on")
	is_on = true

