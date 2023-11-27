extends Node

var image = load("res://Player/Model/pajamas/player_front_pajamas.png")
var material_test = load("res://Assets/Materials/pajamas_front.tres")
@onready var mesh = $playerTest/metarig/Skeleton3D/body

func _ready():
	pass


func _input(event):
	if Input.is_action_just_pressed("interact"):
		#$playerTest.transform.rotated = Vector3(1, 0, 0)
		$playerTest.rotate_x(90)
		$playerTest.translate(Vector3(2, 2, 2))
		#$Label.text = "player dummy position now: " + str($playerTest.position)
		$Label.text = "player dummy rotation now: " + str($playerTest.rotation)
	if Input.is_action_just_pressed("run"):
		print("mesh: " + str(mesh))
		var material = mesh.get_surface_override_material(2)
		mesh.set_surface_override_material(2, material_test)
		print(material)
		#material.albedo_texture = image
		#mesh.set_surface_override_material(2, material)
