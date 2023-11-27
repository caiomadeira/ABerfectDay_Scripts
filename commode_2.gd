extends Interactable

@onready var pajamas_texture = preload("res://Player/Model/pajamas/player_front_pajamas.png")
@onready var animation = $Drawer1AnimationPlayer

@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
var can_interact: bool = true
var is_open: bool = false

func action_use():
	if can_interact:
		if is_open:
			close()
		else:
			open()

func close():
	animation.play("drawer_closed")
	can_interact = false
	is_open = false

func open():
	animation.play("drawer_open")
	can_interact = false
	is_open = true

func _on_drawer_1_animation_player_animation_finished(_anim_name):
	can_interact = true
