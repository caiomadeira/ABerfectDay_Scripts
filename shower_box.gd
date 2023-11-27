extends Interactable

@onready var animation_player = $ShowerBoxDoorAnimationPlayer
@onready var door_collision = $shower_box/shower_box_door2/StaticBody3D/CollisionShape3D

var is_open := false
var can_interact := true

func _ready():
	door_collision.disabled = false

func action_use():
	if is_open:
		close()
	else:
		open()
	
func close():
	door_collision.disabled = false
	animation_player.play("door_closed")

	is_open = false
	
func open():
	door_collision.disabled = true
	animation_player.play("door_opened")
	is_open = true
