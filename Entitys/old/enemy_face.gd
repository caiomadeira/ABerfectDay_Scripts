extends Node3D

@onready var enemy = $face
@onready var animation_player = $face/FaceEnemyAnimationPlayer
@onready var player = get_node("/root/Level1/Player")

func _ready():
	enemy.visible = true

func spawn_rules(location: String, delay: float):
	match location:
		"bedroom_window":
			await get_tree().create_timer(delay).timeout
			enemy.position = Vector3(-0.841, 1.905, 1.016)
			enemy.rotation = player.rotation

func enemy_effect():
	spawn_rules("bedroom_window", 1.0)

