extends Node

@onready var animation_player = $AnimationPlayer


func open_door():
	print("open door")
	animation_player.play("Open")
	await animation_player.animation_finished
	animation_player.play("Opened")


func close_door():
	print("close door")
	animation_player.play("Close")
	await animation_player.animation_finished
	animation_player.play("Closed")
