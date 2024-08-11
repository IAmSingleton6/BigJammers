class_name FireBlock
extends Block

@onready var sprite_2d = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@export var steam_particle_scene: PackedScene


func _ready():
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.WINDGROUP):
		print("fire block grown stronger by wind")


func _on_area_exited(other):
	if other.is_in_group(GroupManager.WINDGROUP):
		print("fire block back to normal wind")


func destroy_block(group_name: String) -> void:
	super(group_name)
	
	if group_name == GroupManager.WATERGROUP:
		
		print("fire block distinguishes by water")
		var steam = steam_particle_scene.instantiate()
		get_tree().root.add_child(steam)
		steam.global_position = global_position
		
		audio_stream_player_2d.reparent(get_tree().root)
		audio_stream_player_2d.play()
		audio_stream_player_2d.finished.connect(audio_stream_player_2d.queue_free)
		var pos = global_position
		await get_tree().process_frame
		audio_stream_player_2d.global_position = pos
		
		queue_free()
