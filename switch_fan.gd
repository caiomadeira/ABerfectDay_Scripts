extends Interactable

@onready var switch_light_audio = $AudioStreamPlayer3D
@onready var light = $light_rooftop

func _ready():
	switch_light_audio.stream = load("res://Assets/Sounds/switch_light.ogg")
	switch_light_audio.pitch_scale = randf_range(.8, 1.2)
	if GlobalScript.livingroom_light_on:
		light.visible = true
	else:
		light.visible = false

func action_use():
	if GlobalScript.livingroom_light_on:
		turn_off()
	else:
		turn_on()

func turn_on():
	switch_light_audio.play()
	light.visible = true
	GlobalScript.is_spinning = true
	GlobalScript.livingroom_light_on = true
	
func turn_off():
	switch_light_audio.play()
	light.visible = false
	GlobalScript.livingroom_light_on = false
	GlobalScript.is_spinning = false
