class_name ShakeCamera2D
extends Camera2D

@export var max_offset : float = 5.0
@export var max_roll : float = 5.0
@export var shakeReduction : float = 2.5

var stress : float = 0.0
var shake : float = 0.0


# TODO: Add in some sort of rotation reset.
func _process(_delta):  
	_process_shake(global_transform.origin, 0.0, _delta)


func _process_shake(center, angle, delta) -> void:
	shake = stress * stress
	rotation_degrees = angle + (max_roll * shake *  _get_noise(randi(), delta))
	
	var os = Vector2()
	os.x = (max_offset * shake * _get_noise(randi(), delta + 1.0))
	os.y = (max_offset * shake * _get_noise(randi(), delta + 2.0))
	
	offset.x = center.x + os.x
	offset.y = center.y + os.y
		
	stress -= (shakeReduction / 100.0)
	
	stress = clamp(stress, 0.0, 1.0)


func _get_noise(noise_seed, time) -> float:
	var n: FastNoiseLite = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
	n.seed = noise_seed
	n.octaves = 4
	n.period = 20.0
	n.persistence = 0.8
	
	return n.get_noise_1d(time)


func add_stress(amount : float) -> void:
	stress += amount
	stress = clamp(stress, 0.0, 1.0)
