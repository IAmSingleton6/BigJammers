extends Node
class_name Level

# has to be load, not preload, or else the world scene corrupts
@onready var world_scene = load("res://scenes/map/world1.tscn")
@export var level_start_time := 2

var player
var won := false

func _ready() -> void:
	Events.level_lose.connect(_on_level_lose)
	player = get_tree().get_first_node_in_group(GroupManager.PLAYERGROUP)
	
	await get_tree().create_timer(level_start_time).timeout
	Events.level_start.emit()


func _process(_delta) -> void:
	# TODO: ADD BACK 
	# _check_win()
	if Input.is_action_just_pressed(InputManager.restart_level):
		SceneTransitions.restart_scene()


func _check_win() -> void:
	if won:
		return
	
	var block_count := get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	if block_count > 0:
		return
	
	print("win")
	Events.level_win.emit()
	won = true
	
	LevelManager.set_current_level_completed()
	SceneTransitions.change_scene_path(world_scene)


func _on_level_lose() -> void:
	SceneTransitions.restart_scene()
