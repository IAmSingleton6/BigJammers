extends Area2D
class_name Water


func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(other):
	if other.is_in_group(GroupManager.FIREGROUP):
		print("water evaporates from fire block")
		destroy_block()
	if other.is_in_group(GroupManager.ICEGROUP):
		print("water freezes over from ice block")

func destroy_block():
	queue_free()
