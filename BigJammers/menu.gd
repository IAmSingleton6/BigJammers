class_name MainMenu
extends Control

@onready var play = $MarginContainer/HBoxContainer/VBoxContainer/Play as Button
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
@onready var options_menu = $options_menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var world_map = load("res://scenes/map/world1.tscn")

func _ready():
	handle_connecting_signals()

func _on_play_pressed():
	print("Pressed Play")
	SaveSystem.save_all_data()
	SceneTransitions.change_scene_path(world_map)
	
func _on_options_pressed():
	print("Pressed Options")
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	
func _on_exit_pressed():
	get_tree().quit()
	
func on_exit_options_menu():
	margin_container.visible = true
	options_menu.visible = false
	
	 
	
func handle_connecting_signals():
	play.pressed.connect(_on_play_pressed)
	options.pressed.connect(_on_options_pressed)
	exit.pressed.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
