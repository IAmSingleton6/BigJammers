extends Panel
class_name UITimer

@onready var minutes_label : Label = $Minutes
@onready var seconds_label : Label = $Seconds
@onready var milliseconds_label : Label = $Milliseconds


func set_time(time: float) -> void:
	var msec := fmod(time, 1)
	var seconds := fmod(time, 60)
	var minutes := fmod(time, 3600) / 60
	minutes_label.text = "%02d:" % minutes
	seconds_label.text = "%02d.:" % seconds
	milliseconds_label.text = "%02d:" % msec
