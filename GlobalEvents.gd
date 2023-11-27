extends Node

@onready var enemy1_texture = load("res://Assets/Textures/Characters/entitys/ski1.png")

# ENTITY_LOCATION_EVENT
enum EntityEvent {
	GENERIC_GARDEN_STAND,
	GENERIC_HALL_STAND,
	GENERIC_FRONT_STAND,
	GENERIC_KITCHEN_STAND,
	GENERIC_BATHROOM_STAND,
	GENERIC_LIVINGROOM_STAND
}

enum ClockEvent {
	WORK_CLOCK_EVENT,
	SLEEP_CLOCK_EVENT
}

func clock_event(event: ClockEvent, player: Player):
	match event:
		0:
			player.audio

func entity_event(event: EntityEvent):
	match event:
		0:
			if !GlobalScript.is_day:
				var enemy = Sprite3D.new()
				var animated_sprite_3d = AnimatableBody3D.new()
				add_child(enemy)
				enemy.add_child(animated_sprite_3d)
				enemy.texture = enemy1_texture
				enemy.set_billboard_mode(1)
				enemy.shaded = true
				enemy.set_position(GlobalScript.garden_bedroom_window_location)
				enemy.set_scale(Vector3(0.7, 0.7, 1))
		
		
