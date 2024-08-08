extends FeelComponent
class_name FeelGameSpeed

@export var time_scale: float = 0.5
@export var transition_time: float = 1.0
@export var reset_speed_after_time: bool = true

var timer: Timer


func play() -> void:
	timer = Timer.new()
	add_child(timer)
	# change to stop once finished debugging
	timer.timeout.connect(_on_timer_timeout)
	timer.start(transition_time if not reset_speed_after_time else 2 * transition_time)
	TimeManager.set_game_speed(time_scale, transition_time, reset_speed_after_time)
	print("start gamespeed")


func _on_timer_timeout() -> void:
	print("end gamespeed")
	stop()
