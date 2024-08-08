extends Camera2D
class_name ShakeCamera2D

@export var max_offset: float = 5.0
@export var max_roll: float = 5.0
@export var shake_reduction: float = 2.5

var stress: float = 0.0
var shake: float = 0.0

var original_offset: Vector2
var original_rotation: float

var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	original_offset = offset
	original_rotation = rotation_degrees
	
	# Configure the noise generator
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 4
	noise.frequency = 20.0
	noise.fractal_gain = 0.8

func _process(delta: float) -> void:
	_process_shake(0.0, delta)

func _process_shake(angle: float, delta: float) -> void:
	if stress > 0.0:
		shake = stress * stress
		rotation_degrees = original_rotation + angle + (max_roll * shake * _get_noise(randi(), delta))
		
		var os = Vector2()
		os.x = max_offset * shake * _get_noise(randi(), delta + 1.0)
		os.y = max_offset * shake * _get_noise(randi(), delta + 2.0)
		
		offset = original_offset + os
		
		stress -= shake_reduction * delta / 100.0
		stress = clamp(stress, 0.0, 1.0)
	else:
		# Reset the camera to its original position and rotation
		offset = original_offset
		rotation_degrees = original_rotation

func _get_noise(noise_seed: int, time: float) -> float:
	noise.seed = noise_seed
	return noise.get_noise_1d(time)

func add_stress(amount: float) -> void:
	stress += amount
	stress = clamp(stress, 0.0, 1.0)
