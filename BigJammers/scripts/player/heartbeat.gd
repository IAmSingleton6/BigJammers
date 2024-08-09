extends Node
class_name HeartBeat 

signal health_depleted
signal damage_taken

@onready var audio_stream_player_heartbeat = $AudioStreamPlayer_heartbeat
@onready var heartbeat_timer = $HeartbeatTimer

@export var anim_sprite : AnimatedSprite2D
@export var min_time_between_heartbeats := 0.5
@export var max_time_between_heartbeats := 2.3

var max_health := 20.0
var health := 20.0
var reduce_health_with_time := false

func init(new_max_health: float):
	max_health = new_max_health
	health = max_health


func _ready():
	Events.level_start.connect(_on_level_start)
	heartbeat_timer.timeout.connect(_on_heartbeat_timeout)
	heartbeat_timer.start(_get_heartbeat_interval())
	if anim_sprite:
		anim_sprite.material.set_shader_parameter("cutoff", 1.0)


func _on_level_start():
	reduce_health_with_time = true


func _process(delta):
	if reduce_health_with_time:
		health -= delta
		health = max(health, 0)
		var health_01 := health/max_health
		if health>0:
			if anim_sprite:
				anim_sprite.material.set_shader_parameter("cutoff", health_01)
			MusicManager.set_drums_volume_01(1 - max(health_01 - 0.5, 0.0))
	
	if health <= 0:
		anim_sprite.material.set_shader_parameter("cutoff", 0 )
		health_depleted.emit()
		Events.level_lose.emit()
		set_process(false)


func take_damage(amount: float) -> void:
	health -= amount
	damage_taken.emit()


func kill():
	print("Heart killed")
	take_damage(health)


func _get_heartbeat_interval() -> float:
	return lerp(min_time_between_heartbeats, max_time_between_heartbeats, health / max_health)


func _on_heartbeat_timeout() -> void:
	audio_stream_player_heartbeat.play()
	heartbeat_timer.start(_get_heartbeat_interval())


func _on_heart_area_entered(other) -> void:
	if other.is_in_group(GroupManager.FIREGROUP):
		kill()
	if other.is_in_group(GroupManager.WATERGROUP):
		kill()
	if other.is_in_group(GroupManager.LASERGROUP):
		kill()


func _exit_tree():
	MusicManager.set_drums_volume_01(0)
