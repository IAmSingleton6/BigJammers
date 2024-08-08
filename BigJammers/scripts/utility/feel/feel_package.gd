extends Node
class_name FeelPackage

signal finished
var components: Array[FeelComponent] = []
var active_components: int = 0
var playing: bool = false


func _ready() -> void:
	for child in get_children():
		if child is FeelComponent:
			components.append(child)
			child.finished.connect(_on_component_finished)


# Start playing each component
# Parallel -> play component right away
# Sequential -> all prior components must be completed first before play
# If component is pause, do not trigger next component 
func play() -> void:
	if playing:
		return
	
	playing = true
	var loop: bool = true
	while components.size() > 0 and loop:
		if components[0] is FeelPause:
			loop = false
		if components[0].order == "Parallel":
			_play_next_component()
		else:
			if active_components == 0:
				_play_next_component()
			else:
				return
	playing = false


func _play_next_component() -> void:
	active_components += 1
	components[0].play()
	components.pop_front()


# If active components are 0, continue play
# If components are 0 also, stop play
# If forceplay, the next component will play without waiting for the previous components (FeelPause)
func _on_component_finished(force_play: bool = false) -> void:
	active_components -= 1
	if active_components < 1 or force_play:
		if components.size() > 0:
			play()
		else:
			stop()


func stop() -> void:
	finished.emit()
	queue_free()
