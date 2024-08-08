class_name TimerBlock
extends Block

@onready var timeout_timer: Timer = $TimeoutTimer
@onready var label: Label = $TimerText/Label
@onready var area_2d = $Area2D

@export var timeout: float = 5


func _ready():
	timeout_timer.timeout.connect(_timeout)
	start_timer()
	area_2d.area_entered.connect(_on_area_entered)


func start_timer():
	timeout_timer.start(timeout)


func _process(_delta):
	label.text = str(timeout_timer.time_left + 1).pad_decimals(0)


func _on_area_entered(_other):
	pass


func _timeout():
	queue_free()
