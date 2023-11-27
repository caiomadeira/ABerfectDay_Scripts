extends Node

var icon = TextureRect.new()
@onready var key_icon = preload("res://Assets/Textures/UI/icons/key_icon.png")
@onready var cup_icon = preload("res://Assets/Textures/UI/icons/cup_icon.png")
@onready var default_icon = preload("res://Assets/Textures/UI/icons/default_icon.png")
@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")

var items: Array = []
	
func add_item(name):
	if !items.has(name):
		_create_icon(name)
		items.append(name)

func remove_item(name):
	if items.has(name):
		if is_instance_valid(icon):
			player_node.remove_child(icon)
		items.erase(name)
		
func _create_icon(name):
	var item_icon_posx = 10
	icon.expand_mode = true
	icon.set_stretch_mode(icon.STRETCH_KEEP_ASPECT)
	for item in items:
		item_icon_posx += 10
		item._set_position(Vector2(item_icon_posx, 10))
	icon.set_size(Vector2(24, 24))
	match name:
		"Key":
			icon.texture = key_icon
		"Cup":
			icon.texture = cup_icon
		_:
			icon.texture = default_icon
	player_node.add_child(icon)
