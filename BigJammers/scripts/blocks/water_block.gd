extends CollisionShape2D
class_name WaterBlock

@onready var area_2d: Area2D = $Area2D
@export var steam_particle_scene: PackedScene

func _ready():
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.FIREGROUP):
		print("evaporate water via fire")
		var steam = steam_particle_scene.instantiate()
		get_tree().root.add_child(steam)
		steam.global_position = global_position
		
		destroy_block()


func destroy_block():
	await get_tree().physics_frame
	# await get_tree().create_timer(0.5).timeout
	queue_free()
