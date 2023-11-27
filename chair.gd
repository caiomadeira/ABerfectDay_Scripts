extends Interactable

@onready var chair = get_node("chair")
@onready var player = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
var is_sitting := GlobalScript.is_sitting

func _ready():
	GlobalScript.is_sitting = is_sitting

func _input(_event):
	if Input.is_action_just_pressed("f - leave") and is_sitting:
		standing()

func action_use():
	is_sitting = true
	GlobalScript.is_sitting = is_sitting
	if is_sitting:
		seated()
	else:
		standing()
		
func seated():
	print("sitting")
	#$chair/chair2/StaticBody3D/CollisionShape3D.disabled = true
	player.position = Vector3(1.49, 1.209, -2.941)
	player.rotation = Vector3(0, 90, 0)
	is_sitting = true
	GlobalScript.is_sitting = is_sitting
	
func standing():
	print("not sitting")
	#$chair/chair2/StaticBody3D/CollisionShape3D.disabled = true
	player.position = Vector3(1.776, 1.129, -0.659)
	player.rotation = Vector3(0, 0, 0)
	is_sitting = false
	GlobalScript.is_sitting = is_sitting
