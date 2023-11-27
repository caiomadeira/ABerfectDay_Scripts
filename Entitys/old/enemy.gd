# roam = vagar
extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavAgent

var speed:= 3.0
var nav_range:= 50
var target_location: Vector3

var current_state = EnemyStates.roam
var player: Player

var look_at_var = Vector3.ZERO

enum EnemyStates {
	roam, 
	chase
}

func _ready():
	randomize()
	get_roam_location()

func get_roam_location():
	var next_location = Vector3.ZERO
	if next_location == Vector3.ZERO:
		next_location = roam_location()
		print("Trying for next location: ", next_location)

func roam_location() -> Vector3:
	var orig_pos = global_position
	target_location = Vector3(orig_pos.x+(nav_range * randf_range(-1.0, 1.0)), 
								orig_pos.y, 
								orig_pos.z+(nav_range * randf_range(-1.0, 1.0)))
	nav_agent.set_target_position(target_location)
	print(target_location, "As the target location, is it reachable?", nav_agent.is_target_reachable())
	
	if nav_agent.is_target_reachable(): # se o agente consegue navegar pelo ambiente
		return target_location # retorna a posicao desejada
	else:
		return Vector3.ZERO # se nao, retorna zero
	
func _physics_process(delta):
	if current_state == EnemyStates.roam:
		if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
			var next_location = nav_agent.get_next_path_position()
			velocity = global_position.direction_to(next_location) * speed
			if !is_on_floor():
				velocity.y -= 10
			move_and_slide()
			
			look_at_var = look_at_var.lerp(Vector3(next_location.x, 0, next_location.z), .1)
			look_at(look_at_var)
			rotation.x = 0
		else:
			get_roam_location()
	if current_state == EnemyStates.chase:
		velocity = global_position.direction_to(player.global_position) * speed * 2.5
		look_at_var = look_at_var.lerp(Vector3(player.global_position.x, 0, player.global_position.z), .1)
		look_at(look_at_var)
		if !is_on_floor():
			velocity.y -= 10
		move_and_slide()

func _on_player_detection_area_body_entered(body):
	if body is Player:
		print("Player detected")
		current_state = EnemyStates.chase
		player = body
		$TimeToRoam.start()

func _on_time_to_roam_timeout():
	print("State now is Roam")
	current_state = EnemyStates.roam


func _on_player_death_area_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	pass
