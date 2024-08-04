extends CharacterBody2D
class_name Player

signal health_depleted

@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var heartbeat_timer : Timer = $HeartbeatTimer

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
var moving := true


func _ready():
	# Get block count TEST DELETE
	var t = get_tree().get_nodes_in_group(GroupManager.BLOCKGROUP).size()
	print(t)
	heartbeat_timer.timeout.connect(_on_health_depleted)
	pass 

func _process(delta):
	#_flip_sprite()
	pass

# Call on level ready on level start, and on level start when animation of 
# start level is complete
func on_level_ready():
	moving = false

# Give specific time
func on_level_start(time: float):
	moving = true
	start_heartbeat_timer(time)

func start_heartbeat_timer(time: float):
	heartbeat_timer.start(time)
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
	_gravity(delta)
	_check_jump()
	_movement(delta)
	_drag(delta)
	
	velocity = motion
	move_and_slide()

func _movement(delta: float):
	var movement : Vector2 = InputManager.get_movement()
	motion.x += movement.x * MOVEMENTSPEED

func _drag(delta: float) -> void:
	var damping = _get_damping()
	motion.x *= 1.0 / (1.0 + delta * damping)

func _get_damping() -> float:
	return DAMPING
	return PhysicsServer2D.body_get_direct_state(get_rid()).total_linear_damp
	
func _coyote_time(jump_pressed: bool, on_floor: bool) -> bool:
	if not on_floor and was_on_floor:
		if not jumping:
			coyote_timer.start(COYOTETIME)
	
	if on_floor and not was_on_floor:
		coyote_timer.stop()
	
	if jump_pressed:
		if not coyote_timer.is_stopped():
			coyote_timer.stop()
			_jump()
			return true
	
	return false

func _jump_buffer(jump_pressed: bool, on_floor: bool) -> bool:
	if on_floor and not was_on_floor:
		if not jump_buffer_timer.is_stopped():
			if Input.is_action_just_pressed(InputManager.jump_input):
				jump_buffer_timer.stop()
				_jump()
				return true
	
	if jump_pressed:
		if not on_floor:
			jump_buffer_timer.start(JUMPBUFFERTIME)
	
	return false

func _check_jump():
	var on_floor : bool = is_on_floor()
	var jump_pressed : bool = Input.is_action_just_pressed(InputManager.jump_input)
	
	if on_floor:
		motion.y = 0
	
	if _coyote_time(jump_pressed, on_floor) or _jump_buffer(jump_pressed, on_floor):
		return
	
	if jump_pressed:
		if on_floor:
			_jump()
	
	# When stop holding jump, fall faster
	if jumping:
		if not Input.is_action_pressed(InputManager.jump_input):
			jumping = false
	
	was_on_floor = on_floor

func _jump():
	jumping = true	
	motion.y = -abs(JUMPVELOCITY)

func _gravity(delta: float):
	var gravity_multiplier : float = 1.0 if jumping else FALL_GRAVITY_MULTIPLIER
	motion.y += GRAVITY * gravity_multiplier


func _on_health_depleted():
	health_depleted.emit()
