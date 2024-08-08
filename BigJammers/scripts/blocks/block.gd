class_name Block
extends CollisionShape2D


func destroy_block(group_name: String) -> void:
	if group_name == GroupManager.LASERGROUP:
		TimeManager.freeze_frame(0.05, 0.1)
		print("block distinguishes by laser")
		queue_free()
