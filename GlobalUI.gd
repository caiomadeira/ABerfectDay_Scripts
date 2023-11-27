extends Node

@onready var texture = preload("res://Assets/Textures/UI/window2.png")
@onready var game_utils = get_node("/root/GlobalGameUtils")
@onready var dogicalbold_font = preload("res://Assets/Fonts/dogicapixelbold.ttf")
@onready var dogicalregular_font = preload("res://Assets/Fonts/dogicapixel.ttf")

func setup_3dviewer_ui(parent: Object, text: String, description: String):
	var texture_rect = TextureRect.new()
	if GlobalScript.is_in_3d_viewer:
		texture_rect.texture = texture
		texture_rect.set_texture_filter(1) 
		texture_rect.position = Vector2(5, 20)
		texture_rect.scale = Vector2(1.2, 1.5)
		parent.add_child(texture_rect)
		texture_rect.add_child(setup_label(text, texture_rect, dogicalbold_font, 12, Vector2(texture_rect.position.x * 2, texture_rect.position.y * 2.5)))
		texture_rect.add_child(setup_label(description, texture_rect, dogicalregular_font, 8, Vector2(texture_rect.position.x * 2, texture_rect.position.y * 4)))

func setup_label(text: String, texture_rect: TextureRect, font: Font, font_size: int, position: Vector2) -> Label:
		var label = Label.new()
		label.text = text
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color(0, 0, 0))
		label.position = position
		return label
