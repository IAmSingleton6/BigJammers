extends FeelComponent
class_name FeelFreezeFrame

@export var time_scale: float = 0.5
@export var duration: float = 1.0

var timer: Timer


func play() -> void:
	timer = Timer.new()
	add_child(timer)
	# change to stop once finished debugging
	timer.timeout.connect(_on_timer_timeout)
	timer.start(duration)
	TimeManager.freeze_frame(time_scale, duration)
	print("start freeze frame")


func _on_timer_timeout() -> void:
	print("end freeze frame")
	stop()
