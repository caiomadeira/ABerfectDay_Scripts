extends SubViewportContainer

@onready var opentap_sprite2d = $SubViewport/open_tap_animations
@onready var putpaste_sprite2d = $SubViewport/put_paste_animations
@onready var openmouth_sprite2d = $SubViewport/open_mouth_animations

@onready var blackwhite_shader = load("res://Assets/Materials/shader/blackwhite_shader_material.tres")

func _ready():
	putpaste_sprite2d.visible = false
	openmouth_sprite2d.visible = false
	GlobalScript.is_brushing_his_teeth = true
	opentap_sprite2d.play("open_tap")

func _process(delta):
	#GlobalScript.has_brushed_teeth = true
	pass

func _on_open_tap_animations_animation_finished():
	opentap_sprite2d.material = blackwhite_shader
	await get_tree().create_timer(1).timeout
	opentap_sprite2d.set_position(Vector2(211.81, 150.155))
	opentap_sprite2d.set_scale(Vector2(1.5, 1.5))
	await get_tree().create_timer(1).timeout
	putpaste_sprite2d.visible = true
	putpaste_sprite2d.play("put_paste")

func _on_put_paste_animations_animation_finished():
	putpaste_sprite2d.material = blackwhite_shader
	await get_tree().create_timer(1).timeout
	putpaste_sprite2d.set_position(Vector2(211.81, 360))
	putpaste_sprite2d.set_scale(Vector2(1.5, 1.5))
	await get_tree().create_timer(1).timeout
	openmouth_sprite2d.visible = true
	openmouth_sprite2d.play("open_mouth")

func _on_open_mouth_animations_animation_finished():
	openmouth_sprite2d.material = blackwhite_shader
	await get_tree().create_timer(1).timeout
	openmouth_sprite2d.set_position(Vector2(502, 240))
	openmouth_sprite2d.set_scale(Vector2(1.8, 1.8))
