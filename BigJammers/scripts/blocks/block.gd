class_name Block
extends CollisionShape2D

@onready var laser_audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var particles_on_laser_destroy: PackedScene = load("res://scenes/particles/steam_3.tscn")


func destroy_block(group_name: String) -> void:
	if group_name == GroupManager.LASERGROUP:
		add_child(laser_audio_player)
		laser_audio_player.reparent(get_parent().get_parent())
		laser_audio_player.stream = load("res://assets/audio/sfx/laser.wav")
		laser_audio_player.volume_db = -7
		laser_audio_player.play()
		
		var particles = particles_on_laser_destroy.instantiate()
		get_parent().get_parent().add_child(particles)
		await get_tree().process_frame
		laser_audio_player.global_position = global_position
		particles.global_position = global_position
		
		print("block distinguishes by laser")
		queue_free()
