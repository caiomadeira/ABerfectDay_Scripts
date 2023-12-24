extends Node3D


var is_on: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_on:
		$lamps/street_lamp4/SpotLight3D.visible = true
		$lamps/street_lamp2_7/SpotLight3D.visible = true
		$lamps/street_lamp2_6/SpotLight3D.visible = true
		$lamps/street_lamp2_5/SpotLight3D.visible = true
		$lamps/street_lamp2_3/SpotLight3D.visible = true
		$lamps/street_lamp2/SpotLight3D.visible = true
		$lamps/street_lamp3/SpotLight3D.visible = true
		$lamps/street_lamp2_4/SpotLight3D.visible = true
	else:
		$lamps/street_lamp4/SpotLight3D.visible = false
		$lamps/street_lamp2_7/SpotLight3D.visible = false
		$lamps/street_lamp2_6/SpotLight3D.visible = false
		$lamps/street_lamp2_5/SpotLight3D.visible = false
		$lamps/street_lamp2_3/SpotLight3D.visible = false
		$lamps/street_lamp2/SpotLight3D.visible = false
		$lamps/street_lamp3/SpotLight3D.visible = false
		$lamps/street_lamp2_4/SpotLight3D.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
