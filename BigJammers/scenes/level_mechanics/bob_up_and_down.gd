extends Node2D

@export var amplitude := 1.0
@export var frequency := 1.0
@onready var default_position = position
var time = 0


func _process(delta : float) -> void:
	time += delta * frequency
	position = (default_position + Vector2(0, sin(time) * amplitude))
