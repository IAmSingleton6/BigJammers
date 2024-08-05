extends Node
class_name HeartBeat 

signal health_depleted
signal damage_taken

@onready var audio_stream_player_heartbeat = $AudioStreamPlayer_heartbeat
@onready var heartbeat_timer = $HeartbeatTimer

@export var min_time_between_heartbeats := 0.5
@export var max_time_between_heartbeats := 2.3
@export var max_health := 60

var health: float
var reduce_health_with_time := false

func _ready():
	health = max_health
	Events.level_start.connect(_on_level_start)
	heartbeat_timer.timeout.connect(_on_heartbeat_timeout)
	heartbeat_timer.start(_get_heartbeat_interval())


func _on_level_start():
	reduce_health_with_time = true


func _process(delta):
	if reduce_health_with_time:
		health -= delta
		health = max(health, 0)
	
	if health <= 0:
		health_depleted.emit()
		set_process(false)


func take_damage(amount: float) -> void:
	health -= amount
	damage_taken.emit()


func _get_heartbeat_interval() -> float:
	return lerp(min_time_between_heartbeats, max_time_between_heartbeats, health / max_health)


func _on_heartbeat_timeout() -> void:
	audio_stream_player_heartbeat.play()
	heartbeat_timer.start(_get_heartbeat_interval())
