extends Node
class_name FeelComponent 

signal finished(force_play: bool)

@export_enum("Parallel", "Sequential") var order: String = "Parallel"

# For each component:
# 1. Have the function play determine the start of the functionality
# 2. Have stop be called when the functionality has concluded (deletes object)


func play() -> void:
	stop()


func stop(force_play: bool = false) -> void:
	finished.emit(force_play)
	queue_free()
