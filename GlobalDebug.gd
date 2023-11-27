extends Node

#@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
@onready var player_camera_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player/Camera3D")
@onready var time_system = get_node("/root/GlobalTimeSystem")

var playerPosLabel = Label.new()
var playerRotLabel = Label.new()
var cameraPosLabel = Label.new()
var cameraRotLabel = Label.new()

var clockSystemLabel = Label.new()

func _ready():
	playerPosLabel._set_position(Vector2(10, 30))
	playerRotLabel._set_position(Vector2(10, 40))
	cameraPosLabel._set_position(Vector2(10, 50))
	cameraRotLabel._set_position(Vector2(10, 60))
	clockSystemLabel._set_position(Vector2(10, 70))
	
	playerPosLabel.add_theme_font_size_override("font_size", 10)
	playerRotLabel.add_theme_font_size_override("font_size", 10)
	cameraPosLabel.add_theme_font_size_override("font_size", 10)
	cameraRotLabel.add_theme_font_size_override("font_size", 10)
	clockSystemLabel.add_theme_font_size_override("font_size", 10)
	clockSystemLabel.add_theme_color_override("font_color", Color(1, 0.5, 0))
	
	add_child(playerPosLabel)
	add_child(playerRotLabel)
	add_child(cameraPosLabel)
	add_child(cameraRotLabel)
	add_child(clockSystemLabel)
	pass
	
func _process(delta):
	#playerPosLabel.text = "Player Pos: " + str(player_node.get_position())
	#playerRotLabel.text = "Player Rot: " + str(player_node.get_rotation())
	
	#cameraPosLabel.text = "Camera Pos: " + str(player_camera_node.get_position())
	#cameraRotLabel.text = "Camera Rot: " + str(player_camera_node.get_rotation())
	
	#clockSystemLabel.text = "Clock: " + time_system.start_global_clock(delta)
	pass
