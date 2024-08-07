extends CollisionShape2D
class_name TimerBlock

@onready var timeout_timer: Timer = $TimeoutTimer
@onready var label: Label = $TimerText/Label
@onready var area_2d = $Area2D

@export var timeout: float = 5


func _ready():
	timeout_timer.timeout.connect(destroy_block)
	start_timer()
	area_2d.area_entered.connect(_on_area_entered)


func start_timer():
	timeout_timer.start(timeout)


func _process(_delta):
	label.text = str(timeout_timer.time_left + 1).pad_decimals(0)


func destroy_block():
	queue_free()


func _on_area_entered(other):
	if other.is_in_group(GroupManager.LASERGROUP):
		print("disintegrate timer block")
		destroy_block()
