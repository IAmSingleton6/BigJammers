extends Area2D
class_name SadPickup


# Could add timer to the effect?

func _ready() -> void:
	body_entered.connect(_on_player_entered)


func _on_player_entered(other) -> void:
	if other.is_in_group(GroupManager.PLAYERGROUP):
		(other as Player).can_jump = false
		_disable_pickup()


func _disable_pickup():
	queue_free()
