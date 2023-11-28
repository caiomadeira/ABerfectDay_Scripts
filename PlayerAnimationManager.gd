class_name PlayerAnimationManager
extends Node

#@onready var inventory = get_node("/root/Inventory")

var interactable_animation: Dictionary = {
	"light_switch": "interact_click",
	"cup": "interact_cup",
	"Door": "will_be_interact",
	"Key": "with_key"
}

var HOLDING_IDLE_ANIMATION: Dictionary = {
	"cup": ["action_cup_coffe", "action_cup_empty"],
}


var ACTIONS_ANIMATION: Dictionary = {
	"CLOCK": "action_clock",
	"SMOKING": "action_smoking"
}

enum PlayerAnimationState {
	ANIMATION_WILL_INTERACT = 0,
	ANIMATION_IDLE = 1,
	ANIMATION_ACTION = 2
}

enum PlayerIDLEManager {
	ANIMATION_DEFAULT_IDLE = 0,
	ANIMATION_CIGAR_IDLE = 1,
	ANIMATION_HOLDING_ITEM = 2
}

enum PlayerActionManager {
	ANIMATION_CLOCK_ACTION = 0,
	ANIMATION_SMOKING_ACTION = 1
}
var player = Player.new()
var inventory = Inventory.new()
var player2d_lefthand = player.player2d_lefthand
var player2d_righthand = player.player2d_righthand
var player2d_lefthand_animation = player.player2d_lefthand_animation
var player2d_righthand_animation = player.player2d_righthand_animation

# usar um sinal para ver se a funcao foi chamada
func setup_player_animations(rightHand: Sprite3D, leftHand: Sprite3D, righthand_animation: AnimatedSprite3D, lefthand_animation: AnimatedSprite3D):
	player2d_lefthand = leftHand
	player2d_righthand = rightHand
	player2d_lefthand_animation = lefthand_animation
	player2d_righthand_animation = righthand_animation
	print("[+][PlayerAnimationManager] - SETUP FINISHED: ")

func play(interactcast: RayCast3D, manager, animation: int):
	var config: Array = []
	if manager == PlayerIDLEManager:
		config = _animation_config(manager, animation, "ANIMATION_IDLE")
	elif  manager == PlayerAnimationState:
		config = _animation_config(manager, animation, "ANIMATION_WILL_INTERACT")
	elif  manager == PlayerActionManager:
		config = _animation_config(manager, animation, "ANIMATION_ACTION")
	else:
		print("noooooooo")
		
	_player_animations(interactcast, config[0], config[1], config[2])
		
func _animation_config(manager, animation, animation_group) -> Array:
	var config: Array = []
	var animation_manager = null
	var animation_secondary_manager = manager
	var idle = null
	var action = null
	var manager_keys = manager.keys()
	for key2 in PlayerAnimationState:
		if key2 == animation_group: # if key2 == "ANIMATION_IDLE":
			for key3 in animation_secondary_manager:
				if animation_secondary_manager[str(key3)] == animation:
					if animation_group == "ANIMATION_IDLE":
						animation_manager = PlayerAnimationState[str(key2)]
						idle = animation_secondary_manager[str(key3)]
						action = null
					elif animation_group == "ANIMATION_WILL_INTERACT":
						animation_manager = PlayerAnimationState[str(key2)]
						idle = null
						action = null
					elif animation_group == "ANIMATION_ACTION":
						animation_manager = PlayerAnimationState[str(key2)]
						idle = null
						action = animation_secondary_manager[str(key3)]
						
			
	config.append(animation_manager)
	config.append(idle)
	config.append(action)
	#print("config: ", config)
	if  animation_group == "ANIMATION_ACTION":
		print("config: ", config)
	return config
		
func _player_animations(interactcast: RayCast3D, animation_manager: PlayerAnimationState, idle = null, action = null) -> void:
	if player2d_lefthand != null and player2d_righthand != null and player2d_lefthand_animation != null and player2d_righthand_animation != null:
		if GlobalScript.player_can_interact:
				match animation_manager:
					0:
						if interactcast != null:
							_ANIMATION_WILL_INTERACT(interactcast)
						else:
							print("RayCast is null.")
					1:
						if idle != null:
							_ANIMATION_IDLE(idle)
					2:
						if action != null:
							_ANIMATION_ACTION(action)
					_:
						if idle != null:
							_ANIMATION_IDLE(idle)
	else:
		print("Player hands or animation player is null.")
				
func _ANIMATION_ACTION(action_manager: PlayerActionManager):
	match action_manager:
		0: # CLOCK
			_PROCESS_ANIMATION("action_clock", "ACTION", "")
		1: # SMOKING
			_PROCESS_ANIMATION("action_smoking", "ACTION", "")
			
func _ACTION_CLOCK():
	if GlobalScript.is_looking_clock:
		player2d_lefthand.visible = true
		player2d_righthand_animation.visible = false
		player2d_lefthand_animation.flip_h = true
		player2d_lefthand_animation.scale = Vector3(1.8, 1.8, 1.8)
		player2d_lefthand_animation.play("action_clock")
	else:
		player2d_lefthand.visible = false
		player2d_righthand_animation.visible = true
		player2d_lefthand_animation.flip_h = false
	
func _ANIMATION_IDLE(idle_manager: PlayerIDLEManager):
	GlobalScript.animation_has_played = false
	if !GlobalScript.is_resting:
		match idle_manager:
			0: # DEFAULT
				_PROCESS_ANIMATION("idle", "IDLE", "")
			1: # CIGAR
				_PROCESS_ANIMATION("idle_cigarbox", "IDLE", "cigar")
			2: # HOLDING ITEM
				#print("INVENOTRY.ITEMS: ", inventory.objects) 
				if GlobalScript.is_holding_item:
					for object in HOLDING_IDLE_ANIMATION.keys():
						if inventory.objects.has(object) and HOLDING_IDLE_ANIMATION[object] is Array:
							#for animation in HOLDING_IDLE_ANIMATION[object]:
							_PROCESS_ANIMATION("action_cup_empty", "IDLE", object)
	else:
		player2d_righthand.visible = false

func _ANIMATION_WILL_INTERACT(interactcast: RayCast3D):
	if interactable_animation.keys().has(interactcast.get_collider().name):		
			print("object will interact name: ", interactcast.get_collider().name)
			print("animation for object: ", interactable_animation[interactcast.get_collider().name])
			_PROCESS_ANIMATION(interactable_animation[interactcast.get_collider().name], "WILL_INTERACT", interactcast.get_collider().name)
	else:
		print("Is Not in DICTIONARY OF INTERACTABLE WITH ANIMATION: ", interactcast.get_collider())
					
func _PROCESS_ANIMATION(animation: String, type: String, object: String = ""):
	match type:
		"WILL_INTERACT":
					player2d_righthand.visible = true
					player2d_righthand_animation.play(animation)
		"IDLE":
			#print("PROCESS ANIMATION IDLE OBJECT: ", object)
			match object:
				"cigar":
					# SMOKE IDLE
					if GlobalScript.can_smoke and !GlobalScript.is_smoking and !GlobalScript.is_looking_clock and GlobalScript.is_holding_item:
						GlobalScript.player_can_interact = false
						player2d_righthand.position.x = GlobalScript.player_righthand_default_position.x
						player2d_lefthand_animation.play(animation)
						player2d_righthand_animation.play("idle_cigarette")
						player2d_lefthand.visible = true
					else:
						GlobalScript.player_can_interact = false
				"cup":
					if GlobalScript.is_holding_item and inventory.objects.has("cup"):
						GlobalScript.player_can_interact = false
						player2d_lefthand.visible = false
						player2d_righthand.visible = true
						player2d_righthand_animation.play(animation)
						player2d_lefthand.visible = false
					else:
						GlobalScript.player_can_interact = true
				"Key":
					if inventory.objects.has("Key") and GlobalScript.is_holding_item:
						player2d_righthand_animation.play(animation)
				"":
					# DEFAULT IDLE
					if !GlobalScript.is_looking_clock and !GlobalScript.is_holding_item:
						#print("IDLE: default idle")
						player2d_righthand.visible = true
						player2d_righthand_animation.play(animation)
						player2d_lefthand.visible = false
					else:
						pass
		"ACTION":
			# SMOKING ACTION
			if GlobalScript.can_smoke and GlobalScript.is_smoking and GlobalScript.is_holding_item:
				player2d_lefthand.visible = false
				player2d_righthand.position.x = -0.221
				player2d_righthand_animation.play(animation)
			
			# CLOCK ACTION
			if GlobalScript.is_looking_clock:
				player2d_lefthand.visible = true
				player2d_righthand_animation.visible = false
				player2d_lefthand_animation.flip_h = true
				player2d_lefthand_animation.scale = Vector3(1.8, 1.8, 1.8)
				#player2d_lefthand_animation.play("action_clock")
				player2d_lefthand_animation.play(animation)
			else:
				player2d_lefthand.visible = false
				player2d_righthand_animation.visible = true
				player2d_lefthand_animation.flip_h = false
