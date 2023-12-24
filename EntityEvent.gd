class_name EntityEvent
extends Node


@onready var player = get_node("/root/Level1/SubViewportContainer/SubViewport/Player")
var angel1 = preload("res://Scenes/Entitys/angel1.tscn")
var entity_instance = null


enum Entity {
	ANGEL1_ENTITY = 0
}

enum EventType {
	ENTITY_STANDING_HALL = 0
}

const ENTITY_SPAWN_HALLFINAL = Vector3(20, 0, 5.525)
const ENTITY_SPAWN_FRONTDOOR = Vector3(28, 0, -0.98)
const ENTITY_SPAWN_BEDROOMMIDDLE = Vector3(2.374, 0, 2.103)

func _ready():
	entity_event(Entity.ANGEL1_ENTITY, EventType.ENTITY_STANDING_HALL)

func _process(delta):
	if GlobalScript.is_hall_light_on:
		entity_instance.visible = false
	else:
		entity_instance.visible = true

func entity_event(entity: Entity, event_type: EventType):
	match event_type:
		0:
			match entity:
				Entity.ANGEL1_ENTITY: 
					entity_instance = create_entity(Entity.ANGEL1_ENTITY)
					if entity_instance != null:
						entity_instance.position = ENTITY_SPAWN_HALLFINAL
						_play_animation(entity_instance, "bye")
						self.add_child(entity_instance)

func create_entity(entity: Entity):
	var entity_instance = null
	match entity:
		0:
			var animation_player = null
			entity_instance = angel1.instantiate()
			entity_instance.name = "angel1"
			entity_instance.rotation = Vector3(0, -185.5, 0)
			entity_instance.scale = Vector3(0.75, 0.75, 0.75)
			
	return entity_instance
			
func _play_animation(instance: Object, name: String):
	var animation_player = null
	if instance != null:
		for node in instance.get_children():
			for anim_player in node.get_children():
				if anim_player is AnimationPlayer:
					animation_player = anim_player	
		animation_player.play(name)

func _get_entity_name() -> String:
	var parent = get_parent()
	var entity_name = ""
	for entities in parent.get_children():
		if entities.name == self.name:
			for entity in entities.get_children():
				entity_name = entity.name
	print(entity_name)
	return entity_name
