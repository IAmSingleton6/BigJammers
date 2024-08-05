extends Node
class_name HeartBeat 

signal health_depleted
signal damage_taken
var health := 60
var reduce_health_with_time := false

func _ready():
	Events.level_start.connect(_on_level_start)


func _on_level_start():
	reduce_health_with_time = true


func _process(delta):
	if reduce_health_with_time:
		health -= delta
	
	if health <= 0:
		health_depleted.emit()
		set_process(false)


func take_damage(amount: float) -> void:
	health -= amount
	damage_taken.emit()
