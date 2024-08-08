extends Node

@onready var current_time_scale := Engine.time_scale
var tween: Tween


func freeze_frame(time_scale: float, duration: float) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1.0


func set_game_speed(new_time_scale: float, transition_time: float = 1.0, reset_speed_after_time: bool = true) -> void:
	if transition_time <= 0:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	if not reset_speed_after_time:
		current_time_scale = new_time_scale
	_start_tween(new_time_scale, transition_time, reset_speed_after_time)


func _start_tween(new_time_scale: float, transition_time: float, reset_speed_after_time: bool) -> void:
	tween.tween_property(Engine, "time_scale", new_time_scale, transition_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN)
	if reset_speed_after_time:
		tween.tween_property(Engine, "time_scale", current_time_scale, transition_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN)
