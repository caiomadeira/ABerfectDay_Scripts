extends Interactable

#@onready var subview_camera = get_node("/root/Level1/SubViewportContainer/SubViewport/TheHouse/Livingroom/SubViewport/")
#@onready var cateye_camera = get_node("/root/Level1/SubViewportContainer/SubViewport/TheHouse/Livingroom/SubViewport/CatEyeCamera3D")
#@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
#@onready var color_rect = get_node("/root/Level1/SubViewportContainer/SubViewport/TheHouse/Livingroom/SubViewport/CatEyeCamera3D/ColorRect")

func _ready():
	#color_rect.visible = false
	pass

func action_use():
	_enter_camera()

func _enter_camera():
	#color_rect.visible = true
	#GlobalScript.is_spying = true
	#GlobalScript.is_mov_enable = false
	#player_node.player_crosshair.visible = false
	#cateye_camera.current = true
	#cateye_camera.fov = 80
	#if Input.is_action_pressed("leave") and GlobalScript.is_spying:
		#_exit_camera()
	pass

func _exit_camera():
	#color_rect.visible = false
	#GlobalScript.is_spying = false
	#GlobalScript.is_mov_enable = true
	#player_node.player_crosshair.visible = false
	#cateye_camera.current = false
	#player_node.camera_3d.current = true
	#player_node.set_position(Vector3(26.606, 1.065, -0.803))
	pass

