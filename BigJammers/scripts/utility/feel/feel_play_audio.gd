extends FeelComponent
class_name FeelPlayAudio

@export var audio: AudioStream
@export var parent_node: Node

var timer: Timer


func play() -> void:
	print("play")
	if not audio:
		return
	print("play2")
	
	var audio_player = AudioStreamPlayer2D.new()
	if parent_node:
		parent_node.add_child(audio_player)
	
	audio_player.set_stream(audio)
	audio_player.stream.loop = false
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()
	stop()
