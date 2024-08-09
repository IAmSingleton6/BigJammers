extends FeelComponent
class_name FeelModulateColorChanger

@export var node_to_change: CanvasItem
@export var color: Color
@export var duration = 1.0
@export var return_to_original = false


func play() -> void:
	var tween = get_tree().create_tween()
	print("play modulate")
	tween.tween_property(node_to_change, "self_modulate", color, duration);
	if return_to_original:
		tween.tween_property(node_to_change, "self_modulate", node_to_change.self_modulate, duration);
	tween.finished.connect(_stop)


func _stop():
	stop()
