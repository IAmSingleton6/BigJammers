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
var level_won := false

func init(new_max_health: float):
	max_health = new_max_health
	health = max_health


func _ready():
	Events.level_start.connect(_on_level_start)
	Events.level_win.connect(func(): level_won = true)
	heartbeat_timer.timeout.connect(_on_heartbeat_timeout)
	heartbeat_timer.start(_get_heartbeat_interval())
	if anim_sprite:
		anim_sprite.speed_scale = 0.0
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
		if anim_sprite:
			anim_sprite.material.set_shader_parameter("cutoff", 0 )
		health_depleted.emit()
		Events.level_lose.emit()
		set_process(false)


func take_damage(amount: float) -> void:
	health -= amount
	damage_taken.emit()


func kill():
	if level_won:
		return
	print("Heart killed")
	take_damage(health)
	anim_sprite.animation = &"base"


func _get_heartbeat_interval() -> float:
	return lerp(min_time_between_heartbeats, max_time_between_heartbeats, health / max_health)


func _on_heartbeat_timeout() -> void:
	audio_stream_player_heartbeat.play()
	var heart_beat_interval = _get_heartbeat_interval()
	heartbeat_timer.start(heart_beat_interval)
	
	if anim_sprite:
		anim_sprite.frame = 0
		var anim_length = get_current_animation_length()
		anim_sprite.speed_scale = anim_length / heart_beat_interval if anim_length > 0 else 1.0


func get_current_animation_length(animated_sprite: AnimatedSprite2D = anim_sprite) -> float:
	var current_animation_name = animated_sprite.animation
	if current_animation_name == "":
		print("No animation is currently playing.")
		return -1.0
	var sprite_frames = animated_sprite.sprite_frames
	if sprite_frames and sprite_frames.has_animation(current_animation_name):
		var num_frames = sprite_frames.get_frame_count(current_animation_name)
		var anim_speed = sprite_frames.get_animation_speed(current_animation_name)
		if anim_speed > 0:
			return num_frames / anim_speed
		else:
			return -1.0
	else:
		return -1.0


func _on_heart_area_entered(other: Node) -> void:
	if other.get_parent() and other.get_parent() is Block:
		return
	
	if other.is_in_group(GroupManager.FIREGROUP):
		kill()
	if other.is_in_group(GroupManager.WATERGROUP):
		kill()
	if other.is_in_group(GroupManager.LASERGROUP):
		kill()
	if other.is_in_group(GroupManager.KILLZONE):
		kill()


func _exit_tree():
	MusicManager.set_drums_volume_01(0)
