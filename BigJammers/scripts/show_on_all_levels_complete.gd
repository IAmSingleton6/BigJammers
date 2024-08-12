extends Node2D


func _ready():
	visible = LevelManager.all_levels_completed
	if LevelManager.all_levels_completed:
		var firework = load("res://scenes/particles/fireworks.tscn").instantiate()
		get_parent().get_parent().get_parent().add_child(firework)
		await get_tree().process_frame
		firework.global_position = global_position
