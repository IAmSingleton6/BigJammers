extends Area2D
class_name RotationPlate


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(other):
	if other.is_in_group(GroupManager.PLAYERGROUP):
		other.
