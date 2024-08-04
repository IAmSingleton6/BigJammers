extends CollisionShape2D

@onready var area_2d: Area2D = $Area2D


func _ready():
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.WINDGROUP):
		print("fire block grown stronger by wind")
	if other.is_in_group(GroupManager.WATERGROUP):
		print("fire block distinguishes by water")
		destroy_block()


func _on_area_exited(other):
	if other.is_in_group(GroupManager.WINDGROUP):
		print("fire block back to normal wind")


func destroy_block():
	queue_free()
