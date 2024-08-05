extends Node2D
class_name LevelIcon

@onready var area_2d = $Area2D
@onready var level_label = $Control/Label
@export var level_data: LevelData

var level_currently_selectable := false 


func _ready():
	level_label.text = str(level_data.level_name)
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)


func _process(_delta):
	if level_currently_selectable:
		if Input.is_action_just_pressed("Jump"):
			on_level_selected()


func _on_body_entered(other):
	# Safety check
	if other.is_in_group(GroupManager.PLAYERGROUP):
		level_currently_selectable = true


func _on_body_exited(other):
	# Safety check
	if other.is_in_group(GroupManager.PLAYERGROUP):
		level_currently_selectable = false


func on_level_selected():
	SceneTransitions.change_scene_path(level_data.scene)
