extends Interactable

@onready var switch_light = get_node("light/SpotLight3D")
@onready var switch_light_audio = $AudioStreamPlayer3D
#var is_light_on := false

func _ready():
	switch_light_audio.stream = load("res://Assets/Sounds/switch_light.ogg")
	switch_light_audio.pitch_scale = randf_range(.8, 1.2)
	if GlobalScript.rooftop_light_on:
		switch_light.visible = true
	else:
		switch_light.visible = false

func action_use():
	if GlobalScript.rooftop_light_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	#lamp.set_surface_override_material(0, mat_on)
	switch_light_audio.play()
	switch_light.visible = true
	GlobalScript.rooftop_light_on = true
	
func turn_off():
	#lamp.set_surface_override_material(0, mat_off)
	switch_light_audio.play()
	switch_light.visible = false
	GlobalScript.rooftop_light_on = false
