extends FeelComponent
class_name FeelPause

# Creates a pause between components
# If immediately after a component, will always play at the same time
# Will stop once timeout is reached
# If next node is parallel, will play immediately after pause is finished
# If next node if sequential, will play after all prior nodes finished including pause

@export var pause_time: float = 2.0


func play() -> void:
	print("start pause")
	var timer := Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_pause_timeout)
	if pause_time == 0:
		pause_time = 0.01
	timer.start(absf(pause_time))


func _on_pause_timeout() -> void:
	print("end pause")
	stop(true)
