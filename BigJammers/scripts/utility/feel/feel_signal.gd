extends FeelComponent
class_name FeelSignal

signal feel_signal


func play() -> void:
	feel_signal.emit()
	stop()
