extends Interactable

# pajamas
@onready var pajamas_front = load("res://Assets/Materials/player_outfits/pajamas_front.tres")
@onready var pajamas_back = load("res://Assets/Materials/player_outfits/pajamas_back.tres")
@onready var skin_color = load("res://Assets/Materials/player_outfits/hand_skin.tres")

# worker
@onready var worker_front = load("res://Assets/Materials/player_outfits/worker_front.tres")
@onready var worker_back = load("res://Assets/Materials/player_outfits/worker_back.tres")
@onready var shoes1 = load("res://Assets/Materials/player_outfits/shoes1.tres")
@onready var shoes2 = load("res://Assets/Materials/player_outfits/shoes2.tres")
# prop
@onready var worker_prop = load("res://Assets/Textures/worker_prop.png")
@onready var pajama_prop = load("res://Assets/Textures/pajamas_prop.png")

@onready var audio = $AudioStreamPlayer3D

func _ready():
	audio.stream = load("res://Assets/Sounds/wear_cloth.ogg")
	audio.pitch_scale = randf_range(.8, 1.2)

func action_use():
	audio.play()
	if GlobalScript.is_with_pajamas:
		$Sprite3D.texture = pajama_prop
		type = "Pajamas"
		GlobalScript.is_with_pajamas = false
	else:
		$Sprite3D.texture = worker_prop
		type = "Work"
		GlobalScript.is_with_pajamas = true
		
