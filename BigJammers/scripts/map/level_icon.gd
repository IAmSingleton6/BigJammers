extends Node2D
class_name LevelIcon

@onready var level_label = $Label

@export var level_data: LevelData

@export var level_right: LevelIcon
@export var level_left: LevelIcon
@export var level_up: LevelIcon
@export var level_down: LevelIcon

var completed := false
var unlocked := false

func _ready():
	_get_save_data()
	level_label.text = str(level_data.level_name)


func _get_save_data():
	var save_data = SaveSystem.load_data(level_data.level_name)
	completed = save_data["completed"] if typeof(save_data) == TYPE_DICTIONARY and save_data.has("completed") else false
	unlocked = save_data["unlocked"] if typeof(save_data) == TYPE_DICTIONARY and save_data.has("unlocked") else level_data.level_unlocked
