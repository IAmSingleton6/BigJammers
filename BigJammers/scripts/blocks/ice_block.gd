extends CollisionShape2D
class_name IceBlock

const WATER_BLOCK = preload("res://scenes/blocks/water_block.tscn")
@onready var area_2d: Area2D = $Area2D
@export var steam_particle_scene: PackedScene

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other) -> void:
	if other.is_in_group(GroupManager.FIREGROUP):
		print("fire makes ice block water block")
		melt()


func melt() -> void:
	var water_instance = WATER_BLOCK.instantiate()
	water_instance.global_position = global_position
	water_instance.global_rotation = global_rotation
	water_instance.global_scale = global_scale
	get_parent().add_child(water_instance)
	var steam = steam_particle_scene.instantiate()
	get_tree().root.add_child(steam)
	steam.global_position = global_position
	destroy_block()


func destroy_block() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()
