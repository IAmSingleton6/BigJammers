class_name IceBlock
extends Block

const WATER_BLOCK = preload("res://scenes/blocks/water_block.tscn")
@onready var area_2d: Area2D = $Area2D
@export var steam_particle_scene: PackedScene


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(_other) -> void:
	pass


func destroy_block(group_name: String) -> void:
	super(group_name)
		
	if group_name == GroupManager.FIREGROUP:
		call_deferred("melt")


func melt() -> void:
	var water_instance = WATER_BLOCK.instantiate()
	get_parent().add_child(water_instance)
	water_instance.global_position = global_position
	water_instance.global_rotation = global_rotation
	water_instance.global_scale = global_scale
	
	var steam = steam_particle_scene.instantiate()
	get_tree().root.add_child(steam)
	steam.global_position = global_position
	
	queue_free()



