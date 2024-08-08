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
	level_label.text = str(level_data.level_name)
