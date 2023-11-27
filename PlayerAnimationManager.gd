extends Node

@onready var inventory: Inventory = get_node("/root/Inventory")

var interactable_animation: Dictionary = {
	"light_switch": "interact_click",
	"cup": "interact_cup",
	"Door": "will_be_interact",
}

enum PlayerAnimationManager {
	ANIMATION_WILL_INTERACT = 0,
	ANIMATION_IDLE = 1,
	ANIMATION_ACTION = 2
}

enum PlayerIDLEManager {
	ANIMATION_DEFAULT_IDLE = 0,
	ANIMATION_CIGAR_IDLE = 1,
	ANIMATION_HOLDING_ITEM = 2
}

enum PlayeraActionManager {
	ANIMATION_CLOCK_ACTION = 0
}

@onready var player2d_lefthand = Sprite3D
@onready var player2d_righthand = Sprite3D
@onready var player2d_lefthand_animation = Sprite3D
@onready var player2d_righthand_animation = Sprite3D

func setup_player_animations(animation_manager: PlayerAnimationManager, raycast: RayCast3D) -> void:
	if player2d_lefthand != null and player2d_righthand != null and player2d_lefthand_animation != null and player2d_righthand_animation != null:
		if GlobalScript.player_can_interact:
			var interacted = raycast.get_collider()
			match animation_manager:
				0:
					_ANIMATION_WILL_INTERACT(interacted)
				1:
					_ANIMATION_IDLE(PlayerIDLEManager)
				2:
					_ANIMATION_ACTION(PlayeraActionManager)
				_:
					_ANIMATION_IDLE(PlayerIDLEManager)
	else:
		assert("Player hands or animation player is null.")
				
func _ANIMATION_ACTION(action_manager: PlayeraActionManager):
	match action_manager:
		0: # CLOCK
			_ACTION_CLOCK()

func _ACTION_CLOCK():
	if GlobalScript.is_looking_clock:
		print("animation clock started")
		player2d_lefthand.visible = true
		player2d_righthand_animation.visible = false
		player2d_lefthand_animation.flip_h = true
		player2d_lefthand_animation.scale = Vector3(1.8, 1.8, 1.8)
		#player2d_lefthand_animation.play("action_will_see_clock")
		#await get_tree().create_timer(0.5).timeout
		player2d_lefthand_animation.play("action_clock")
	else:
		print("animation clock stopped")
		player2d_lefthand.visible = false
		player2d_righthand_animation.visible = true
		player2d_lefthand_animation.flip_h = false
		player2d_lefthand_animation.play("action_clock")
	
func _ANIMATION_IDLE(idle_manager: PlayerIDLEManager):
	GlobalScript.animation_has_played = false
	if !GlobalScript.is_resting:
		match idle_manager:
			0: # DEFAULT
				_PROCESS_ANIMATION("idle_cigarbox", "IDLE", "")
			1: # CIGAR
				_PROCESS_ANIMATION("idle_cigarbox", "IDLE", "cigar")
			2: # HOLDING ITEM
				if !inventory.items.is_empty():
					for item in inventory.items:
						for object in interactable_animation.keys():		
							if item == object:
								_PROCESS_ANIMATION(object, interactable_animation[object], "IDLE")
	else:
		player2d_righthand.visible = false

func _ANIMATION_WILL_INTERACT(interacted: RayCast3D):
	if is_instance_valid(interacted) and interacted != null:
		if interacted.is_in_group("Interactable") and interacted.is_method("action_use"):
			for object in interactable_animation.keys():		
				if interacted.name == object:
					_PROCESS_ANIMATION(interactable_animation[object], "WILL_INTERACT", object)
				else:
					print("Not match the name.")
					
func _PROCESS_ANIMATION(animation: String, type: String, object: String = ""):
	match type:
		"WILL_INTERACT":
			if GlobalScript.animation_has_played == false:
				player2d_righthand.visible = true
				player2d_righthand_animation.play(animation)
			else:
				player2d_righthand_animation.pause()
		"IDLE":
			match object:
				"cigar":
					# SMOKE IDLE
					if GlobalScript.can_smoke and !GlobalScript.is_smoking and !GlobalScript.is_looking_clock:
						player2d_righthand.position.x = GlobalScript.player_righthand_default_position.x
						player2d_lefthand_animation.play(animation)
						player2d_righthand_animation.play("idle_cigarette")
						player2d_lefthand.visible = true
				"cup":
					if GlobalScript.is_holding_item and inventory.items.has("Cup"):
						GlobalScript.player_can_interact = false
						player2d_lefthand.visible = false
						player2d_righthand.visible = true
						player2d_righthand_animation.play("action_cup_empty")
						player2d_lefthand.visible = false
					else:
						GlobalScript.player_can_interact = true
				"":
					# DEFAULT IDLE
					if !GlobalScript.is_looking_clock:
						player2d_righthand.visible = true
						player2d_righthand_animation.play(animation)
						player2d_lefthand.visible = false
