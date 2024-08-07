class_name Block
extends CollisionShape2D


func destroy_block(group_name: String) -> void:
	if group_name == GroupManager.LASERGROUP:
		print("block distinguishes by laser")
		queue_free()
