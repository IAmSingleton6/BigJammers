extends FeelComponent
class_name FeelScreenShake

@export var camera: ShakeCamera2D
@export_range(0.0, 1.0) var stress_amount: float = 0.5


func play() -> void:
	camera.add_stress(stress_amount)
	stop()
