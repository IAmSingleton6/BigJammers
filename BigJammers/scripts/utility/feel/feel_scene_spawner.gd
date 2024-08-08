extends FeelComponent
class_name FeelSceneSpawner

@export var scene_to_spawn: PackedScene 
@export var node_to_parent: Node
@export var spawn_local_position: Vector3


func play() -> void:
	spawn_scene()
	stop()


func spawn_scene() -> void:
	var instance := scene_to_spawn.instantiate()
	var parent = node_to_parent if node_to_parent else get_tree().root
	parent.add_child(instance)
	if instance is Node2D:
		instance.position = Vector2(spawn_local_position.x, spawn_local_position.y)
	else:
		instance.position = spawn_local_position
