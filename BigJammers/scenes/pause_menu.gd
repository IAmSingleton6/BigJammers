class_name PauseMenu
extends Control

func _ready():
	get_tree().paused = true

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()


#func _on_options_pressed():
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_exit_to_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
