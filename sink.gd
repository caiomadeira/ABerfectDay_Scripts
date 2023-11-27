extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func action_use():
	get_tree().change_scene_to_file("res://Scenes/minigames/brush_teeth.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
