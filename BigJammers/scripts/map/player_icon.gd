extends Node2D
class_name PlayerIcon

@export var speed := 2
var target_position: Vector2


func _process(delta):
	global_position = global_position.lerp(target_position, delta * speed)
