extends CharacterBody2D
class_name Player

@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var coyote_timer : Timer = $CoyoteTimer

@export var MOVEMENTSPEED = 5
@export var DAMPING = 5
@export var GRAVITY = 2
@export var FALL_GRAVITY_MULTIPLIER = 2
@export var JUMPBUFFERTIME : float = 0.3
@export var JUMPVELOCITY : float = 50
@export var COYOTETIME : float = 0.3

var motion: Vector2 = Vector2.ZERO
var jumping : bool = false
var was_on_floor : bool = false
var gravity: Vector3 = Vector3.DOWN


func _ready():
	# Get block count TEST DELETE
	var t = get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	print(t)
	pass 

func _process(delta):
	#_flip_sprite()
	pass

#func _flip_sprite() -> void:
	#var x : float = InputManager.get_movement().x
	#var flip_h: bool = sprite.flip_h
	#
	#if flip_h:
		#if x >= 0.1:
			#flip_h = false
	#else:
		#if x < -0.1:
			#flip_h = true

func _physics_process(delta):
	Gravity(delta)
	CheckJump()
	Movement(delta)
	Drag(delta)
	
	velocity = motion
	move_and_slide()

func Movement(delta: float):
	var movement : Vector2 = InputManager.get_movement()
	motion.x += movement.x * MOVEMENTSPEED

func Drag(delta: float) -> void:
	var damping = GetDamping()
	motion.x *= 1.0 / (1.0 + delta * damping)

func GetDamping() -> float:
	return DAMPING
	return PhysicsServer2D.body_get_direct_state(get_rid()).total_linear_damp
	
func CoyoteTime(jump_pressed: bool, on_floor: bool) -> bool:
	if not on_floor and was_on_floor:
		if not jumping:
			coyote_timer.start(COYOTETIME)
	
	if on_floor and not was_on_floor:
		coyote_timer.stop()
	
	if jump_pressed:
		if not coyote_timer.is_stopped():
			coyote_timer.stop()
			Jump()
			return true
	
	return false

func JumpBuffer(jump_pressed: bool, on_floor: bool) -> bool:
	if on_floor and not was_on_floor:
		if not jump_buffer_timer.is_stopped():
			if Input.is_action_just_pressed(InputManager.jump_input):
				jump_buffer_timer.stop()
				Jump()
				return true
	
	if jump_pressed:
		if not on_floor:
			jump_buffer_timer.start(JUMPBUFFERTIME)
	
	return false

func CheckJump():
	var on_floor : bool = is_on_floor()
	var jump_pressed : bool = Input.is_action_just_pressed(InputManager.jump_input)
	
	if on_floor:
		motion.y = 0
	
	if CoyoteTime(jump_pressed, on_floor) or JumpBuffer(jump_pressed, on_floor):
		return
	
	if jump_pressed:
		if on_floor:
			Jump()
	
	# When stop holding jump, fall faster
	if jumping:
		if not Input.is_action_pressed(InputManager.jump_input):
			jumping = false
	
	was_on_floor = on_floor

func Jump():
	jumping = true	
	motion.y = -abs(JUMPVELOCITY)

func Gravity(delta: float):
	var gravity_multiplier : float = 1.0 if jumping else FALL_GRAVITY_MULTIPLIER
	motion.y += GRAVITY * gravity_multiplier
