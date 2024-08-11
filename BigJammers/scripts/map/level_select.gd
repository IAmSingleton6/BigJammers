extends Node
class_name LevelSelect

static var MAPSAVEUNIQUENAME = "Map"

@onready var levels = $Levels
@onready var current_level: LevelIcon = $Levels/LevelIcon
@onready var player_icon: PlayerIcon = $PlayerIcon
@export var minimum_distance_to_select_again = 15

var current_world := 0
var transitioning_to_scene := false

func _ready():
	# Get last completed level and set to first active map node
	var last_level_completed := false
	var last_level_just_completed := false
	var level_set := false
	for level in levels.get_children():
		if level is LevelIcon:
			# level just completed play anim
			if last_level_just_completed:
				last_level_just_completed = false
				level.set_just_completed()
			
			# Play unlock anim
			if level.level_data == LevelManager._current_level:
				current_level = level
				level_set = true
				if LevelManager.current_level_just_completed:
					last_level_just_completed = true
					
			
			
			level.completed = _get_completed(level.level_data)
			level.unlocked = level.completed or last_level_completed
			last_level_completed = level.completed
			
			if not level_set and level.unlocked:
				current_level = level
	levels.get_children()[0].unlocked = true
	
	player_icon.target_position = current_level.global_position
	player_icon.global_position = current_level.global_position


func _process(_delta):
	if player_icon.global_position.distance_to(current_level.global_position) > minimum_distance_to_select_again:
		return
	
	if transitioning_to_scene:
		return
	
	if Input.is_action_just_pressed(InputManager.pause_input):
		SceneTransitions.change_scene_path("res://scenes/main_menu.tscn")
		transitioning_to_scene = true
	if Input.is_action_just_pressed(InputManager.move_right) and current_level.level_right and current_level.level_right.unlocked:
		current_level = current_level.level_right
		player_icon.target_position = current_level.global_position
	if Input.is_action_just_pressed(InputManager.move_left) and current_level.level_left and current_level.level_left.unlocked:
		current_level = current_level.level_left
		player_icon.target_position = current_level.global_position
	if Input.is_action_just_pressed(InputManager.move_up) and current_level.level_up and current_level.level_up.unlocked:
		current_level = current_level.level_up
		player_icon.target_position = current_level.global_position
	if Input.is_action_just_pressed(InputManager.move_down) and current_level.level_down and current_level.level_down.unlocked:
		current_level = current_level.level_down
		player_icon.target_position = current_level.global_position
	if Input.is_action_just_pressed(InputManager.jump_input):
		LevelManager.set_current_level(current_level.level_data)
		SceneTransitions.change_scene_path(current_level.level_data.scene)
		transitioning_to_scene = true


func _get_completed(level_data: LevelData) -> bool:
	var save_data := SaveSystem.load_data(LevelData.LEVELSAVEUNIQUENAME)
	save_data = save_data[level_data.level_name] if save_data.has(level_data.level_name) else {}
	return save_data["completed"] if save_data.has("completed") else false
