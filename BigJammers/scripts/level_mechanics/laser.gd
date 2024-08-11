extends RaycastElement
class_name Laser

@onready var tween: Tween
@onready var line_2d: Line2D = $Line2D 
@onready var casting_particles = $CastingParticles
@onready var collision_particles = $CollisionParticles
@onready var beam_particles = $BeamParticles


func _ready():
	line_2d.points[1] = Vector2.ZERO
	super()


func _physics_process(_delta):
	var cast_point := target_position
	force_raycast_update()
	
	collision_particles.emitting = is_colliding()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		casting_particles.global_rotation = get_collision_normal().angle() - PI
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
		var collider := get_collider()
		if on_hit_timer.is_stopped():
			if collider.get_parent() is Block:
				(collider.get_parent() as Block).destroy_block(GroupManager.LASERGROUP)
				on_hit_timer.start(time_between_successive_hits)
			if collider.get_parent() is Player:
				(collider.get_parent() as Player).kill()
				on_hit_timer.start(time_between_successive_hits)
	
	line_2d.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func _set_is_casting(cast: bool) -> void:
	super(cast)
	# TODO REMOVE THIS NOT WORKING FOR NOW
	# beam_particles.emitting = is_casting
	beam_particles.emitting = false
	casting_particles.emitting = is_casting
	if not is_casting:
		collision_particles.emitting = false


func appear() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(line_2d, "width", 5.0, 0.2)
	tween.play()


func disappear() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(line_2d, "width", 0.0, 0.2)
	tween.play()
