extends Interactable

@onready var animation_player = $AnimationPlayer

var is_open := false
var can_interact := true
# lock and unlock logic
var is_locked := true # public var
@export_node_path("Area3D") var keyPath
var actual_key #link item to another in scenery

func _ready():
	if keyPath != null:
		actual_key = get_node(keyPath)
	pass

func action_use():
	if is_locked and !is_instance_valid(actual_key):
		is_locked = false
		
	if !is_locked:
		if can_interact:
			if is_open:
				close()
			else:
				open()
	else:
		animation_player.play("door_locked")
	
func close():
	animation_player.play("door_close")
	can_interact = false
	is_open = false
	
func open():
	animation_player.play("door_open")
	can_interact = false
	is_open = true

func _on_animation_player_animation_finished(_anim_name):
	can_interact = true
