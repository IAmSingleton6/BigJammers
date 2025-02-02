extends Area2D
class_name PressurePlate

signal pressure_plate_stepped_on
signal pressure_plate_activated
signal pressure_plate_deactivated

@onready var label: Label = $WeightText/Label

@export var EXACT_AMOUNT_NEEDED := true
@export var BLOCKCOUNT := 2
@export var ONETIMEINTERACTION := false

var activated := false
var stepped_on := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_label(BLOCKCOUNT)


func _process(_delta):
	# Check if blocks get added or removed while pressure plate is stood on
	if not ONETIMEINTERACTION && stepped_on:
		_update_label(BLOCKCOUNT - _get_block_count())


func _on_body_entered(other):
	if ONETIMEINTERACTION and activated:
		return
	
	if not other.is_in_group("Player"):
		return
	
	pressure_plate_stepped_on.emit()
	
	print("pressure plate entered")
	stepped_on = true
	var block_count := _get_block_count()
	_update_label(BLOCKCOUNT - block_count)
	if (EXACT_AMOUNT_NEEDED and not block_count == BLOCKCOUNT) or (not EXACT_AMOUNT_NEEDED and not block_count >= BLOCKCOUNT):
		return
	
	pressure_plate_activated.emit()
	activated = true


func _on_body_exited(other):
	if ONETIMEINTERACTION and activated:
		return
	
	if not other.is_in_group("Player"):
		return
	
	stepped_on = false
	pressure_plate_deactivated.emit()
	activated = false
	_update_label(BLOCKCOUNT)


func _get_block_count() -> int:
	return get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()


func _update_label(count: int) -> void:
	var text = str(count) if count > 0 else "ERROR"
	text = "Activated" if count == 0 or count < 0 and not EXACT_AMOUNT_NEEDED else text
	text = "Error" if count < 0 and EXACT_AMOUNT_NEEDED else text
	label.text = text
	
	if count == 0 or count < 0 and not EXACT_AMOUNT_NEEDED:
		label.self_modulate = Color.GREEN
	elif count < 0 and EXACT_AMOUNT_NEEDED:
		label.self_modulate = Color.RED
	else:
		label.self_modulate= Color.WHITE
