extends Node3D


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Maps/level_1.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_test_enemy_pressed():
	get_tree().change_scene_to_file("res://Maps/level_2.tscn")

func _on_options_pressed():
	if DisplayServer.window_get_mode() == 0:
		DisplayServer.window_set_mode(3)
	elif DisplayServer.window_get_mode() == 3:
		DisplayServer.window_set_mode(0)
