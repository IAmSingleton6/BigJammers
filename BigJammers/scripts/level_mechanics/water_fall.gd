extends RaycastElement
class_name WaterFall

@onready var gpu_particles_2d = $GPUParticles2D


func _physics_process(_delta):
	if not on_hit_timer.is_stopped():
		return
	
	var cast_point := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		var collider := get_collider()
		if on_hit_timer.is_stopped():
			if collider.get_parent() is Block:
				(collider.get_parent() as Block).destroy_block(GroupManager.WATERGROUP)
				on_hit_timer.start(time_between_successive_hits)
			if collider.get_parent() is Player:
				(collider.get_parent() as Player).kill()
				on_hit_timer.start(time_between_successive_hits)


func appear() -> void:
	gpu_particles_2d.emitting = true


func disappear() -> void:
	gpu_particles_2d.emitting = false
