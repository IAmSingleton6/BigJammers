class_name OptionsMenu
extends Control

@onready var exit_tm = $MarginContainer/VBoxContainer/Exit_tm as Button


signal exit_options_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	exit_tm.pressed.connect(on_exit_pressed)
	set_process(false)
	
	
func on_exit_pressed():
	exit_options_menu.emit()
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
