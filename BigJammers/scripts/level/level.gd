extends Node
class_name Level

@export var level_start_time = 2

var player
var won := false

func _ready() -> void:
	Events.level_lose.connect(_on_level_lose)
	player = get_tree().get_first_node_in_group(GroupManager.PLAYERGROUP)
	if player is Player:
		(player as Player).health_depleted.connect(_on_level_lose)
		
	await get_tree().create_timer(level_start_time).timeout
	Events.level_start.emit()


func _process(_delta) -> void:
	_check_win()


func _check_win() -> void:
	if won:
		return
	
	var block_count := get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	if block_count > 0:
		return
	
	print("win")
	Events.level_win.emit()
	won = true


func _on_level_lose() -> void:
	pass
