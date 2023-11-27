class_name Player
extends CharacterBody3D

@onready var floorcast = $FloorDetectionRayCast3D
@onready var camera_3d = $Camera3D
@onready var viewer_mesh = $Camera3D/viewer_mesh
@onready var mesh_utils = get_node("/root/GlobalMeshUtil")

@onready var origCameraPos: Vector3 = camera_3d.position
@onready var footstepSound = $FootstepSound
@onready var interactcast = $Camera3D/InteractableRayCast3D
@onready var prompt_label = $PromptLabel
@onready var game_utils = get_node("/root/GlobalGameUtils")
@onready var UI_utils = get_node("/root/GlobalUi")
@onready var inventory = get_node("/root/Inventory")
# player 2d
@onready var player_main = $"."
@onready var player_collision = $CollisionShape3D
@onready var player_crosshair = $Camera3D/Crosshair
# Right hand (main hand)
@onready var player2d_righthand_animation = $Camera3D/player2d_righthand/AnimatedSprite3D
@onready var player2d_righthand = $Camera3D/player2d_righthand

# Left hand
@onready var player2d_lefthand_animation = $Camera3D/player2d_lefthand/AnimatedSprite3D
@onready var player2d_lefthand = $Camera3D/player2d_lefthand
@onready var hours_label = $Camera3D/player2d_lefthand/AnimatedSprite3D/Hours

@onready var hand_spritesheet = preload("res://Assets/Sprites/player2d_singlehand_spritesheet.tres")
@onready var player_status = get_node("status")

# control label
@onready var control_label = $ControlLabel

# enemy interaction
@onready var enemy_raycast = $Camera3D/EnemyInteractRayCast3D

# Global
@onready var time_system = get_node("/root/GlobalTimeSystem")

# movement
var is_running := false
var mouse_sens := 0.4
var speed := 3
var direction

# animations
enum Player2dAnimations {
	ANIMATION_WILL_BE_INTERACT = 0,
	ANIMATION_IDLE = 1,
	ANIMATION_SMOKING = 2,
	ANIMATION_KEY = 3,
	ANIMATION_CLOCK = 4
}

enum Player2dActions {
	ACTION_CLOCK = 0
}

const GRAVITY = 5
const JUMP_DESLOCATION = 20

# camera shaking
var _delta := 0.0
var cameraBobSpeed := 10
var cameraBobUpDown := 0.3

# audio
var distanceFootstep: = 0.0
var playFootstep: float = 3.0

# signals
signal holding_item

func _ready():
	scene_did_load()

func scene_did_load():
	camera_3d.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Eyes.visible = false
	player_crosshair.visible = true
	player2d_lefthand.visible = false
	hours_label.visible = false
	viewer_mesh.visible = false
	
func _input(event):	
	if GlobalScript.is_mov_enable == true:
		_interact()
		process_camera_basic_moviment(event)
		if GlobalScript.is_resting == false or GlobalScript.is_sitting == false:
			_run()
	else:
		mesh_utils.viewer_input(event, viewer_mesh)
		pass
				
func process_camera_basic_moviment(event):
	if GlobalScript.is_mov_enable == true:
		_zoom(event)
		if GlobalScript.is_resting == false:
			if event is InputEventMouseMotion:
				rotate_y(deg_to_rad(-event.relative.x * mouse_sens)) # rotacione o player
				camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens)) # rotacao no eixo y
				camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-49), deg_to_rad(89)) # clamp limits betweens a min and max values
		else:
			_rest_eyes_control(event)
			if GlobalScript.is_resting:
				if event is InputEventMouseMotion:
					pass
				
				#camera_3d.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
				#camera_3d.rotation.y = clamp(camera_3d.rotation.y, deg_to_rad(-69), deg_to_rad(20))
				#$DebugLabel.text = "Camera 3D Rotation: " + str(camera_3d.rotation) + "\n"
							
func _process(delta):
	if GlobalScript.is_mov_enable == true:
		if direction != null:
			process_camera_walk_shake(delta)
		if floorcast.is_colliding():
			var walkingTerrain = floorcast.get_collider().get_parent()
			if walkingTerrain != null and walkingTerrain.get_groups().size() > 0:
				var terrainGroup = walkingTerrain.get_groups()[0]
				process_ground_sounds(terrainGroup)
		if !GlobalScript.is_spying:
			prompt_text()
			_control_label_text()
			_clock(delta)
	else:
		mesh_utils.viewer_control()
		player2d_animations(Player2dAnimations.ANIMATION_SMOKING)
	
	if interactcast.is_colliding():
		player2d_animations(Player2dAnimations.ANIMATION_WILL_BE_INTERACT)
	else:
		_ANIMATION_idle()
		# CUP IDLE
		if GlobalScript.is_holding_item and inventory.items.has("Cup"):
			GlobalScript.player_can_interact = false
			player2d_lefthand.visible = false
			player2d_righthand.visible = true
			player2d_righthand_animation.play("action_cup_empty")
			player2d_lefthand.visible = false
		else:
			GlobalScript.player_can_interact = true
		
func prompt_text():
	if interactcast.is_colliding():
		if is_instance_valid(interactcast.get_collider()):
			if interactcast.get_collider().is_in_group("Interactable"):
				match interactcast.get_collider().name:
					"cigar":
						GlobalScript.show_item_information = true
					"Door":
						prompt_label.text = "[E] - " + interactcast.get_collider().type
						prompt_label.visible = true
					_:
						GlobalScript.show_item_information = false
						prompt_label.set_position(Vector2(10, game_utils.get_resolution().y - 60))	
						prompt_label.text = "[E] - " + interactcast.get_collider().type
						prompt_label.visible = true
			else:
				prompt_label.visible = false
				
	else:
		prompt_label.visible = false
		GlobalScript.show_item_information = false
		
func _control_label_text():
	control_label.set_position(Vector2(10, game_utils.get_resolution().y - 60))	
	control_label.visible = true
	if GlobalScript.is_resting:
		control_label.text = "[F] - Leave bed\n [BTN 1] - Close/Open eyes"
	elif GlobalScript.computer_is_on:
		control_label.text = "[L] - Logout"
	elif GlobalScript.is_sitting:
		control_label.text = "[F] - Leave"
	elif GlobalScript.can_smoke:
		control_label.text = "[BTN 1] - To Smoke\n [F] - To throw cigarbox away"
	else:
		control_label.visible = false

# make random sounds in the same group terrain
func process_ground_sounds(group: String):
	if is_running:
		playFootstep = 2.0
	else:
		playFootstep = 4.7
	
	if (int(velocity.x) != 0) || int(velocity.z) != 0:
		distanceFootstep += .1
	
	if distanceFootstep > playFootstep and is_on_floor():
		var concrete_sounds = ["footstep_concrete2.ogg", "footstep_concrete.ogg"]
		var wood_sounds = ["footstep_wood1.ogg", "footstep_wood2.ogg", "footstep_wood3.ogg"]
		var carpet_sounds = ["footstep_carpet1.ogg", "footstep_carpet2.ogg"]
		
		match group:
			"WoodTerrain":
				var filename = wood_sounds[randi() % wood_sounds.size()]
				footstepSound.stream = load("res://Assets/Sounds/" + filename)
				
			"ConcreteTerrain":
				var filename = concrete_sounds[randi() % concrete_sounds.size()]
				footstepSound.stream = load("res://Assets/Sounds/" + filename)
			
			"CarpetTerrain":
				var filename = carpet_sounds[randi() % carpet_sounds.size()]
				footstepSound.stream = load("res://Assets/Sounds/" + filename)
				
		footstepSound.pitch_scale = randf_range(.8, 1.2)
		footstepSound.play()
		distanceFootstep = 0.0
		
# read input wich new frame for moviment
func _physics_process(delta):
	_process_movement(delta)

# Player Basic Features
func _process_movement(_delta):
	if GlobalScript.is_mov_enable == true:
		if !GlobalScript.is_sitting:
			direction = Vector3.ZERO
			var h_rot = global_transform.basis.get_euler().y
			
			direction.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
			direction.z = -Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
			direction = Vector3(direction.x, 0, direction.z).rotated(Vector3.UP, h_rot).normalized()

			move_and_slide()
			if !GlobalScript.is_resting:
				_jump(direction)
	
func _jump(jump_direction):
	var actual_speed = speed if !is_running else speed * 1.5
	velocity.x = jump_direction.x * actual_speed
	velocity.z = jump_direction.z * actual_speed
	if GlobalScript.is_resting == false or GlobalScript.is_sitting == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y += JUMP_DESLOCATION
		if !is_on_floor(): # gravity control
			velocity.y -= GRAVITY

func _run():
	if Input.is_action_just_pressed("run"):
		is_running = true
	if Input.is_action_just_released("run"):
		is_running = false
 
func _clock(delta):
	hours_label.text = time_system.start_global_clock(delta)
	if Input.is_action_just_pressed("h - clock") and !GlobalScript.is_looking_clock:
		GlobalScript.is_looking_clock = true
		player2d_animations(Player2dAnimations.ANIMATION_CLOCK)
		player2d_action(Player2dActions.ACTION_CLOCK)
		print("clock pressed: " + str(GlobalScript.is_looking_clock))	
		
	if Input.is_action_just_released("h - clock") and GlobalScript.is_looking_clock:
		GlobalScript.is_looking_clock = false
		player2d_animations(Player2dAnimations.ANIMATION_CLOCK)
		player2d_action(Player2dActions.ACTION_CLOCK)
		print("clock released: " + str(GlobalScript.is_looking_clock))
		
func _interact():
	if Input.is_action_just_pressed("interact"):
		var interacted = interactcast.get_collider()
		if interacted != null and interacted.is_in_group("Interactable") and interacted.has_method("action_use"):
			if GlobalScript.can_smoke == false or GlobalScript.player_can_interact == true:
				interacted.action_use()
				holding_item.emit()
			else:
				print("Cannot interact with a" + str(interactcast.get_collider().name) + " with a cigarette in hand.")
				
		if interacted != null and interacted.is_in_group("Interactable") and interacted.is_in_group("3DViewerObj"):
			match interacted.type:
				"Game1":
					#UI_utils.setup_3dviewer_ui(camera_3d, interacted.type, "Description")
					setup3d_viewer(mesh_utils._get_rigidbody_mesh(interacted))
				"Game2":
					setup3d_viewer(mesh_utils._get_rigidbody_mesh(interacted))
				
		else:
			print(">" +  str(interacted) + ": Not in interactable area. Raycast is not detecting")

func setup3d_viewer(interacted: Object):
	if GlobalScript.is_in_3d_viewer:
		viewer_mesh.visible = true
		player_crosshair.visible = false
		prompt_label.text = "[F] - To leave the 3d viewer"
		player2d_lefthand.visible = false
		player2d_righthand.visible = false
		viewer_mesh.scale = interacted.scale
		viewer_mesh.mesh = interacted.mesh

func _zoom(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.is_pressed():
			print("mouse 2 pressed")
			# camera_3d.projection = 1
			camera_3d.fov = 60
		elif event.button_index == 2 and not event.is_pressed():
			# camera_3d.projection = 0
			camera_3d.fov = 75

func process_camera_walk_shake(delta):
	if !GlobalScript.is_resting:
		_delta += delta
		var cam_bob
		var objCam
		if is_running:
			cam_bob = floor(abs(direction.z) + abs(direction.x)) * _delta * cameraBobSpeed * 1.5
			objCam = origCameraPos + Vector3.UP * sin(cam_bob) * cameraBobUpDown
		elif direction != Vector3.ZERO: # PLAYER IS MOVING
			cam_bob = floor(abs(direction.z) + abs(direction.x)) * _delta * cameraBobSpeed
			objCam = origCameraPos + Vector3.UP * sin(cam_bob) * cameraBobUpDown
		else: # PLAYER IS NOT MOVINGA
			cam_bob = floor(abs(1) + abs(1)) * _delta * .5 # BREATHING CAMERA MOVEMENT
			objCam = origCameraPos + Vector3.UP * sin(cam_bob) * cameraBobUpDown * .5
		camera_3d.position = camera_3d.position.lerp(objCam, delta)
	
# Player Actions
func _rest_eyes_control(event):
	if Input.is_action_just_pressed("click1"):
		print("closing eyes")
		$Eyes.visible = true
		$EyesAnimation.play("player_close_eyes")
		await get_tree().create_timer(1.5).timeout
		GlobalScript.is_eyes_closed = true
				
	if Input.is_action_just_released("click1"):
		print("opening eyes")
		$EyesAnimation.play("player_open_eyes")
		await get_tree().create_timer(1.0).timeout
		GlobalScript.is_eyes_closed = false
			
# Player Animations
func player2d_action(currentAction: Player2dActions):
	match currentAction:
		#clock
		0:
			_ACTION_clock()

func player2d_animations(currentAnimation: Player2dAnimations):
	if GlobalScript.player_can_interact == true:
		var interacted = interactcast.get_collider()
		if interacted != null and interacted.is_in_group("Interactable") and interacted.has_method("action_use"):
			match currentAnimation:
				0:
					_ANIMATION_will_be_interact()
				1:
					_ANIMATION_idle()	
				2:
					_ANIMATION_smoking()
				3:
					_ANIMATION_key()
				4:
					_ANIMATION_see_clock()
		else:
			match currentAnimation:
				4:
					_ANIMATION_see_clock()
	
func _ACTION_clock():
	if GlobalScript.is_looking_clock:
		hours_label.visible = true
		hours_label.z_index = -1
		#hours_label.position = Vector2(200, 500)
	else:
		hours_label.visible = false
	
func _ANIMATION_see_clock():
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
		
func _ANIMATION_key():
	if inventory.items.has("Key") and GlobalScript.is_holding_item:
		player2d_righthand_animation.play("with_key")
		
func _ANIMATION_will_be_interact():
	var object_name = interactcast.get_collider().name
	if is_instance_valid(interactcast.get_collider()):
		if interactcast.get_collider().is_in_group("Interactable"):
			match object_name:
				"light_switch":
					_process_animation("interact_click")
				"cup":
					_process_animation("interact_cup")
				"Door":
					if inventory.items.has("Key"):
						player2d_animations(Player2dAnimations.ANIMATION_KEY)
					else:
						_process_animation("will_be_interact")
				_:
					_process_animation("will_be_interact")

func _ANIMATION_idle():
	GlobalScript.animation_has_played = false
	if !GlobalScript.is_resting:
		# SMOKING IDLE
		if GlobalScript.can_smoke and !GlobalScript.is_smoking and !GlobalScript.is_looking_clock:
			player2d_righthand.position.x = GlobalScript.player_righthand_default_position.x
			player2d_lefthand_animation.play("idle_cigarbox")
			player2d_righthand_animation.play("idle_cigarette")
			player2d_lefthand.visible = true
			
		else:
			# DEFAULT IDLE
			if !GlobalScript.is_looking_clock:
				player2d_righthand.visible = true
				player2d_righthand_animation.play("idle")
				player2d_lefthand.visible = false
	else:
		player2d_righthand.visible = false
		
func _ANIMATION_smoking():
	if GlobalScript.can_smoke and GlobalScript.is_smoking:
		print("player is smoking")
		player2d_lefthand.visible = false
		player2d_righthand.position.x = -0.221
		#player2d_animations(Player2dAnimations.ANIMATION_SMOKING)
		player2d_righthand_animation.play("action_smoking")
		
func _process_animation(animation_name: String):
	if GlobalScript.animation_has_played == false:
		player2d_righthand.visible = true
		player2d_righthand_animation.play(animation_name)
	else:
		player2d_righthand_animation.pause()
		
# ::::::::::::::::::::::::::::::::::::::::::::::
# ::::::::::::::::::::::::::::::::::::::::::::::
#					DELEGATE
# ::::::::::::::::::::::::::::::::::::::::::::::
# ::::::::::::::::::::::::::::::::::::::::::::::

func _on_animated_sprite_3d_frame_changed():
	#print("frame changed: " + str(player2d_righthand_animation.frame) + " of " + str(player2d_righthand_animation.animation))
	if player2d_lefthand_animation.animation == "action_will_see_clock":
		if player2d_lefthand_animation.frame == 4:
			player2d_lefthand_animation.stop()
	
	if player2d_righthand_animation.animation == "interact_cup":
		print("animation: click")
		if player2d_righthand_animation.frame == 3:
			print("frame 2")
			GlobalScript.animation_has_played = true
			print("stop")
	
	else:	
		if !player2d_righthand_animation.animation == "idle_cigarette" or !player2d_righthand_animation.animation == "idle" or player2d_righthand_animation.animation == "action_smoking":
			if !player2d_righthand_animation.animation == "action_cup_empty":
				if player2d_righthand_animation.frame == 2:
					GlobalScript.animation_has_played = true
				
