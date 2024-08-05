extends Node
class_name LevelSelect

@onready var current_level: LevelIcon = $Levels/LevelIcon
@onready var player_icon: PlayerIcon = $PlayerIcon
@export var minimum_distance_to_select_again = 15
var current_world = 0


func _ready():
	player_icon.target_position = current_level.global_position
	player_icon.global_position = current_level.global_position


func _process(_delta):
	if player_icon.global_position.distance_to(current_level.global_position) > minimum_distance_to_select_again:
		return
		
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
		SceneTransitions.change_scene_path(current_level.level_data.scene)
