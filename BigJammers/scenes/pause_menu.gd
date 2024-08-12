class_name PauseMenu
extends Control

@onready var margin_container = $MarginContainer
@onready var options_menu = $options_menu

var paused := false : set = _on_pause
var exiting := false

func _on_pause(value) -> void:
	paused = value
	if paused:
		if not exiting:
			MusicManager.on_pause_start()
			get_tree().paused = true
		visible = value
	else:
		if not exiting:
			MusicManager.on_pause_end()
			get_tree().paused = false
		_on_exit_options_menu()
		visible = false

func _ready():
	options_menu.exit_options_menu.connect(_on_exit_options_menu)

func _process(_delta):
	if Input.is_action_just_pressed(InputManager.pause_input):
		paused = !paused

func _on_resume_pressed():
	paused = false

func _on_exit_options_menu():
	margin_container.visible = true
	options_menu.set_process(false)
	options_menu.visible = false

func _on_exit_to_main_menu_pressed():
	paused = false
	exiting = true
	SceneTransitions.change_scene_path("res://scenes/map/world1.tscn")

func _on_options_menu_pressed():
	print("Pressed Options")
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
