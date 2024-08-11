extends Node2D

@onready var _1 = $"1"
@onready var _2 = $"2"
@onready var _3 = $"3"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	# terrible but for now
	var parent = get_parent()
	var parent_parent = parent.get_parent()
	reparent(parent_parent)
	
	var pos = global_position
	await get_tree().process_frame
	global_position = pos
	
	_1.emitting = true
	audio_stream_player_2d.global_position = _1.global_position
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.7).timeout
	_2.emitting = true
	audio_stream_player_2d.global_position = _2.global_position
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.9).timeout
	_3.emitting = true
	audio_stream_player_2d.global_position = _3.global_position
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play()
