extends Node

var resolutions: Dictionary = {"320x240": Vector2(320, 240),
								"640x480":Vector2(640, 480)}

func _ready():
	set_resolutions()
	
func set_resolutions():
	DisplayServer.window_set_size(resolutions.get("320x240"))

func get_resolution() -> Vector2:
	var width = ProjectSettings.get("display/window/size/viewport_width")
	var height = ProjectSettings.get("display/window/size/viewport_height")
	#print("[+] GameUtils - Screen resolution: " + str(width) + ":" + str(height))
	return Vector2(width, height)

func get_distance_collider_obj(raycast) -> float:
	var origin = raycast.global_transform.origin
	var collision_point = raycast.get_collision_point()
	var distance = origin.distance_to(collision_point)
	print("[+] GameUtils - DISTANCE: " + str(distance))
	return distance

func _fps_counter() -> int:
	var fps = Engine.get_frames_per_second()
	return fps
