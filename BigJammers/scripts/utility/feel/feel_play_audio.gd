extends FeelComponent
class_name FeelPlayAudio

@export var directional := false
@export var volume_db := 0
@export var audio: AudioStream
@export var parent_node: Node

var timer: Timer


func play() -> void:
	print("play")
	if not audio:
		return
	print("play2")
	
	var audio_player: AudioStreamPlayer
	audio_player = AudioStreamPlayer2D.new() if directional else AudioStreamPlayer.new()
	if parent_node:
		parent_node.add_child(audio_player)
	
	audio_player.bus = &"SFX"
	audio_player.volume_db = volume_db
	audio_player.set_stream(audio)
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()
	stop()
