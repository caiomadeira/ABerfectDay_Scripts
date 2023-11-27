extends Node3D

@onready var front_light = $livingroom_props/props/front_light/light_front
var front_light_on: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if front_light_on:
		front_light.visible = true
	else:
		front_light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
