extends FeelComponent
class_name FeelSquashAndStretch

@export var node_to_change: Node
@export var target_scale := Vector3.ONE
@export var duration := 0.1

var tween: Tween

func play() -> void:
	if not node_to_change is Node2D and not node_to_change is Node3D:
		return
		
	var scale = node_to_change.scale
	var target_s = Vector2(target_scale.x * scale.x, target_scale.y * scale.y) if node_to_change is Node2D else target_scale * scale
	tween = get_tree().create_tween()
	
	tween.tween_property(node_to_change, "scale", target_s, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node_to_change, "scale", scale, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_stop)
	
	tween.play()


func _stop():
	stop()
