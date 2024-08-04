extends RayCast2D
class_name Laser

@onready var line_2d: Line2D = $Line2D 
@onready var tween: Tween = create_tween()
@onready var casting_particles = $CastingParticles
@onready var collision_particles = $CollisionParticles
@onready var beam_particles = $BeamParticles

var is_casting:= false : set = _set_is_casting


func _ready():
	line_2d.points[1] = Vector2.ZERO
	is_casting = true

func _physics_process(delta):
	var cast_point := target_position
	force_raycast_update()
	
	collision_particles.emitting = is_colliding()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
		var collider := get_collider()
		if collider is Node:
			if collider.is_in_group(GroupManager.WATERGROUP):
				# manipulate the block in some way some way
				#bcall a specific function in parent if has for example
				print("laser hit water group block: ", collider.name)
	
	line_2d.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func _set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting
	if is_casting:
		appear()
	else:
		collision_particles.emitting = false
		disappear()
	
	set_physics_process(is_casting)


func appear() -> void:
	tween.stop()
	tween.tween_property(line_2d, "width", 10.0, 0.2)
	tween.play()


func disappear() -> void:
	tween.stop()
	tween.tween_property(line_2d, "width", 0, 0.2)
	tween.play()
