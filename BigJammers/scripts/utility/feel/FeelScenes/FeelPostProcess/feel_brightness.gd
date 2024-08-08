extends FeelComponent
class_name FeelBrightness

@export var time = 2


func _ready() -> void:
	set_process(false)


func play() -> void:
	print("start brightness")
	set_process(true)


func _process(delta: float) -> void:
	time -= delta
	if time <= 0:
		print("end brightness")
		stop()
