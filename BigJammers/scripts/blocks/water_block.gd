class_name WaterBlock
extends Block

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var area_2d: Area2D = $Area2D

@export var steam_particle_scene: PackedScene


func _ready():
	area_2d.area_entered.connect(_on_area_entered)
	if not is_in_group(GroupManager.BLOCKGROUP):
		add_to_group(GroupManager.BLOCKGROUP)


func _on_area_entered(_other):
	pass


func destroy_block(group_name: String) -> void:
	super(group_name)
	
	if group_name == GroupManager.FIREGROUP:
		print("evaporate water via fire")
		var steam = steam_particle_scene.instantiate()
		get_tree().root.add_child(steam, true)
		steam.global_position = global_position
		
		audio_stream_player_2d.reparent(get_tree().root)
		audio_stream_player_2d.play()
		audio_stream_player_2d.finished.connect(audio_stream_player_2d.queue_free)
		var pos = global_position
		await get_tree().process_frame
		audio_stream_player_2d.global_position = pos
		
		queue_free()
