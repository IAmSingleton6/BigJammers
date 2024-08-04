extends CollisionShape2D

@onready var area_2d: Area2D = $Area2D


func _ready():
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.FIREGROUP):
		print("evaporate water via fire")
		destroy_block()


func destroy_block():
	queue_free()
