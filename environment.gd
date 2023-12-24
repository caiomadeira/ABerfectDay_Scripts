extends Node3D

@onready var glitch_shader_material = load("res://Assets/PostProcessing/glitch_shader.tres")
@onready var grain_shader_material = load("res://Assets/PostProcessing/grain_shader.tres")
@onready var test_shader_material = load("res://Assets/PostProcessing/test_shader.tres")

@onready var timer_label = $EnvironmentTimerLabel
@onready var time_system = get_node("/root/GlobalTimeSystem")

@onready var world_env = $WorldEnvironment
@onready var day_env_config = load("res://Assets/PostProcessing/outdoor_environment.tres")
@onready var day_env_withproceduralsky_config = load("res://Assets/PostProcessing/day_with_proceduralsky.tres")
@onready var night_env_config = load("res://Assets/PostProcessing/night_environment.tres")

@onready var directional_light = $DirectionalLight3D

var directionallight_initial_pos = Vector3(-22.813, 13.891, 0)
var directionallight_initial_rot = Vector3(0, -90, 0)

func _ready():
	if GlobalScript.is_day:
		#shader.material = glitch_shader_material
		#shader.material = test_shader_material
		directional_light.visible = true
		world_env.environment = day_env_withproceduralsky_config
	else:
		#shader.material = grain_shader_material
		directional_light.visible = false
		world_env.environment = night_env_config

func _process(delta):
	#change_environment_sky(time_system.start_global_clock(delta))
	var time = time_system.start_global_clock(delta)
	if time != "12:00":
		if directional_light.rotation != Vector3(-90, -90, 0) and directional_light.position != Vector3(12, 30, 0):
			directional_light.position.y += delta / 1200
			directional_light.position.x += delta / 1200
			directional_light.rotation.x -= delta / 1200
			#print("Light position Y: " + str(directional_light.position.y))
			#print("Light position X: " + str(directional_light.position.x))
			#print("Light rotation X: " + str(directional_light.rotation.x))
	else:
		directional_light.position == Vector3(12, 30, 0)
		directional_light.rotation = Vector3(-90, -90, 0)

func change_environment_sky(time: String):
	if GlobalScript.is_day:
		match time:
			"06:00":
				print("6 AM")
			"07:00":
				print("7 AM")
			"08:00":
				print("8 AM")
			"09:00":
				print("9 AM")
			"10:00":
				print("10 AM")
			"11:00":
				print("11 AM")
			"12:00":
				print("12 AM")
