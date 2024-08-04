extends Node
class_name Level


func _ready() -> void:
	Events.LevelLose.connect(_on_level_lose)


func _process(_delta) -> void:
	_check_win()


func _check_win() -> void:
	var block_count := get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	if block_count > 0:
		return
	
	print("win")
	Events.LevelWin.emit()


func _on_level_lose() -> void:
	pass
