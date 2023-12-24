class_name Player
extends CharacterBody3D

# Player Animation Manager
@onready var playerAnimationManager = PlayerAnimationManager.new() as PlayerAnimationManager
#@onready var playerAnimationManager = get_node("/root/PlayerAnimationManager")
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
#@onready var inventory = get_node("/root/Inventory")
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

# SIGNALS

# movement
var is_running := false
var mouse_sens := 0.4
var speed := 3
var direction

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
# signal holding_item

func _ready():
	scene_did_load()

func scene_did_load():
	playerAnimationManager.setup_player_animations(
	player2d_righthand, 
	player2d_lefthand,
	player2d_righthand_animation, 
	player2d_lefthand_animation)
	
	#self.HAS_INTERACTED.connect(self.get_interacted_object_name)
	
	camera_3d.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Eyes.visible = false
	player_crosshair.visible = true
	player2d_lefthand.visible = false
	hours_label.visible = false
	viewer_mesh.visible = false
	
func _input(event):	
	if GlobalScript.is_mov_enable == true:
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
			_control_label_text()
			_clock(delta)
	else:
		mesh_utils.viewer_control()
		playerAnimationManager.play(interactcast, playerAnimationManager.PlayerActionManager, 
		playerAnimationManager.PlayerActionManager.ANIMATION_SMOKING_ACTION)
		
func will_interact():
	if interactcast.is_colliding():
		if is_instance_valid(interactcast.get_collider()):
			if interactcast.get_collider().is_in_group("Interactable"):
				playerAnimationManager.play(interactcast, playerAnimationManager.PlayerAnimationState, 
				playerAnimationManager.PlayerAnimationState.ANIMATION_WILL_INTERACT)
				match interactcast.get_collider().name:
					"cigar":
						GlobalScript.show_item_information = true
					_:
						GlobalScript.show_item_information = false
						prompt_label.set_position(Vector2(10, game_utils.get_resolution().y - 60))	
						prompt_label.text = "[E] - " + interactcast.get_collider().type
						prompt_label.visible = true
			else:
				prompt_label.visible = false
	else:
		if !GlobalScript.is_holding_item:
			playerAnimationManager.play(interactcast, playerAnimationManager.PlayerIDLEManager, 
			playerAnimationManager.PlayerIDLEManager.ANIMATION_DEFAULT_IDLE)
		else:
			playerAnimationManager.play(interactcast, playerAnimationManager.PlayerIDLEManager,
			playerAnimationManager.PlayerIDLEManager.ANIMATION_HOLDING_ITEM)
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
	elif GlobalScript.is_holding_item:
		control_label.text = "[F] - Drop item"
		control_label.add_theme_font_size_override("font_size", 16)
		control_label.set_position(Vector2(10, game_utils.get_resolution().y - 40))	
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
	if GlobalScript.is_mov_enable == true:
		if !GlobalScript.is_spying:
			will_interact()
			_interact()
			_has_dropped_item()

			
func _has_dropped_item():
	if playerAnimationManager.current_object != null and Inventory.items.has(playerAnimationManager.current_object) and Input.is_action_just_pressed("f - leave"):
		playerAnimationManager.current_object = null
		GlobalScript.is_holding_item = false

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
		_ACTION_clock()
		playerAnimationManager.play(interactcast,playerAnimationManager.PlayerActionManager, 
		playerAnimationManager.PlayerActionManager.ANIMATION_CLOCK_ACTION)
		
	if Input.is_action_just_released("h - clock") and GlobalScript.is_looking_clock:
		GlobalScript.is_looking_clock = false
		playerAnimationManager.play(interactcast,playerAnimationManager.PlayerActionManager,
		playerAnimationManager.PlayerActionManager.ANIMATION_CLOCK_ACTION)
		
func _interact():
	if Input.is_action_just_pressed("interact"):
		var interacted = interactcast.get_collider()
		if interacted != null and interacted.is_in_group("Interactable") and interacted.has_method("action_use"):
			playerAnimationManager.current_object = interacted.type
			if GlobalScript.can_smoke == false or GlobalScript.player_can_interact == true:
				interacted.action_use()
			else:
				print("Cannot interact with a" + str(interactcast.get_collider().name) + " with a cigarette in hand.")
				
		elif interacted != null and interacted.is_in_group("Interactable") and interacted.is_in_group("3DViewerObj"):
			match interacted.type:
				"Game1":
					setup3d_viewer(mesh_utils._get_rigidbody_mesh(interacted))
				"Game2":
					setup3d_viewer(mesh_utils._get_rigidbody_mesh(interacted))
				
		else:
			pass

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
	
func _ACTION_clock():
	if GlobalScript.is_looking_clock:
		hours_label.visible = true
		hours_label.z_index = -1
		# hours_label.position = Vector2(200, 500)
	else:
		hours_label.visible = false
			
# ::::::::::::::::::::::::::::::::::::::::::::::
# ::::::::::::::::::::::::::::::::::::::::::::::
#					DELEGATE
# ::::::::::::::::::::::::::::::::::::::::::::::
# ::::::::::::::::::::::::::::::::::::::::::::::
				
