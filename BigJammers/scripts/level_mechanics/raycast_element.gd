extends RayCast2D
class_name RaycastElement

@export var time_until_start_firing := 0.0
@export var start_on := true
@export var timed := false 
@export var on_time := 3.0
@export var off_time := 2.0
@export var time_between_successive_hits := 0.1

var fire_timer 
var on_hit_timer

var is_casting:= false : 
	set = _set_is_casting

func _set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	if is_casting:
		appear()
	else:
		disappear()
	
	set_physics_process(is_casting)


var is_timed := false : 
	set(value):
		var old_timed = timed
		timed = value
		
		if old_timed and not value:
			if not fire_timer.is_stopped():
				fire_timer.stop()
		elif not old_timed and value:
			if not fire_timer.is_stopped():
				fire_timer.stop()
			_on_fire_timer_timeout()
	get:
		return timed



func _ready():
	fire_timer = Timer.new()
	fire_timer.one_shot = true
	add_child(fire_timer)
	on_hit_timer = Timer.new()
	on_hit_timer.one_shot = true
	add_child(on_hit_timer)
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	
	
	is_casting = false
	if time_until_start_firing > 0:
		await get_tree().create_timer(time_until_start_firing).timeout
	
	is_casting = start_on
	is_timed = timed
	if timed:
		fire_timer.start(on_time)


func _on_fire_timer_timeout():
	if not timed:
		return
	
	fire_timer.start(off_time if is_casting else on_time)
	is_casting = !is_casting


func appear():
	pass


func disappear():
	pass
