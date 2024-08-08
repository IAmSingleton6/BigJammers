extends FeelComponent
class_name FeelVisibilityTrigger

@export var node_to_change: Node
@export var visibility: bool = false


func play() -> void:
	set_visibility()
	stop()


func set_visibility() -> void:
	if node_to_change is Node2D or node_to_change is Node3D:
		node_to_change.visible = visibility
