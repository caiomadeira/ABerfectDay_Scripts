extends Node

var icon = TextureRect.new()
@onready var key_icon = preload("res://Assets/Textures/UI/icons/key_icon.png")
@onready var cup_icon = preload("res://Assets/Textures/UI/icons/cup_icon.png")
@onready var default_icon = preload("res://Assets/Textures/UI/icons/default_icon.png")
#@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")

var items: Array = []
var player: Player = Player.new() as Player
	
func add_item(name):
	if !items.has(name):
		_draw_icon(name)
		items.append(name)

func remove_item(name):
	if items.has(name):
		if is_instance_valid(icon):
			player.remove_child(icon)
			items.erase(name)

func _draw_icon(name):
	if player != null:
		icon.expand_mode = true
		icon.set_stretch_mode(icon.STRETCH_KEEP_ASPECT)
		icon._set_position(Vector2(10, 10))
		icon.set_size(Vector2(24, 24))
		match name:
			"Key":
				icon.texture = key_icon
			"cup":
				icon.texture = cup_icon
			_:
				icon.texture = default_icon
		player.add_child(icon)
	else:
		print("[+] Inventory: Player is null")
