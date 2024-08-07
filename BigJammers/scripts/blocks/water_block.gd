class_name WaterBlock
extends Block

@onready var area_2d: Area2D = $Area2D
@export var steam_particle_scene: PackedScene


func _ready():
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other):
	pass


func destroy_block(group_name: String) -> void:
	if group_name == GroupManager.FIREGROUP:
		print("evaporate water via fire")
		var steam = steam_particle_scene.instantiate()
		get_tree().root.add_child(steam, true)
		steam.global_position = global_position
		
		queue_free()
