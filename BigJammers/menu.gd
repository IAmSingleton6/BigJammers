extends Control


func _on_play_pressed():
	print("Pressed Play")
	SceneTransitions.change_scene_path("res://scenes/lvl_1.tscn")
	
func _on_options_pressed():
	print("Pressed Options")
	
func _on_exit_pressed():
	get_tree().quit()
