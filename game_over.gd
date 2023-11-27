extends Node


func _on_game_over_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Maps/level_1.tscn")
