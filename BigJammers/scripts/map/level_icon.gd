extends Node2D
class_name LevelIcon

@onready var level_label = $Label
@onready var jail_cell = $JailCell

@export var level_data: LevelData

@export var level_right: LevelIcon
@export var level_left: LevelIcon
@export var level_up: LevelIcon
@export var level_down: LevelIcon

var completed := false
var unlocked := false:
	set(value):
		unlocked = value
		if unlocked:
			set_unlocked()

var level_just_completed := false

func _ready():
	level_label.text = str(level_data.level_name)


func set_just_completed() -> void:
	level_just_completed = true
	jail_cell.find_child("AnimationPlayer").play("unlock")


func set_unlocked() -> void:
	if not level_just_completed:
		jail_cell.find_child("AnimationPlayer").play("unlocked")
