extends Interactable

@onready var player_node = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
@onready var inventory = get_node("/root/Inventory")
@onready var cup_mesh = $cup/cup2

func _ready():
	pass

func action_use():
	GlobalScript.is_holding_item = true
	inventory.add_item("cup")
	queue_free() # delete object from scene
	# GlobalScript.player_can_interact = false
