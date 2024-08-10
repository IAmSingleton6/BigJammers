extends Node
class_name LevelWithPause

# has to be load, not preload, or else the world scene corrupts
@onready var world_scene = load("res://scenes/map/world1.tscn")
@export var level_start_time := 2

# adding pause func requisites -------------------------------
@export var pause_menu_packed_scene : PackedScene = null
@onready var ui_container = $UI_Container as CanvasLayer
# - pause reqs
# -------------------------------------------------------------

var player
var level_ended := false

func _ready() -> void:
	Events.level_lose.connect(_on_level_lose)
	Events.level_win.connect(_on_level_win)
	player = get_tree().get_first_node_in_group(GroupManager.PLAYERGROUP)
	
	await get_tree().create_timer(level_start_time).timeout
	Events.level_start.emit()


func _process(_delta) -> void:
	# TODO: ADD BACK 
	# _check_win()
	if Input.is_action_just_pressed(InputManager.restart_level):
		SceneTransitions.restart_scene()
		
# pause menu? ################################### --------------------------------
	#if Input.is_action_just_pressed("Pause"):
func _unhandled_key_input(event):
	if event.is_action("Pause"):
		print("PAUSED")
		var new_pause_menu : PauseMenu = pause_menu_packed_scene.instantiate()
		ui_container.add_child(new_pause_menu)
	# end pause menu #################################### ------------------------


func _check_win() -> void:
	if level_ended:
		return
	
	var block_count := get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	if block_count > 0:
		return
	
	Events.level_win.emit()


func _on_level_win() -> void:
	if level_ended:
		return
	print("win")
	level_ended = true
	
	LevelManager.set_current_level_completed()
	SceneTransitions.change_scene_path(world_scene)


func _on_level_lose() -> void:
	if level_ended:
		return
	print("lose")
	level_ended = true
	SceneTransitions.restart_scene()


