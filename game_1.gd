extends Interactable

@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")

func _ready():
	pass

func action_use():
	GlobalScript.is_mov_enable = false
	GlobalScript.is_in_3d_viewer = true
	GlobalScript.current_3dview_object = type

func _process(delta):
	if Input.is_action_just_pressed("f - leave") and GlobalScript.is_in_3d_viewer:
		GlobalScript.is_mov_enable = true
		GlobalScript.is_in_3d_viewer = false
		GlobalScript.current_3dview_object = ""
		print("exit 3d viewer")
		player_node.viewer_mesh.mesh = null
		player_node.player_crosshair.visible = true
		player_node.player2d_righthand.visible = true
		print("camera 3d:" + str(player_node.camera_3d.get_children()))
