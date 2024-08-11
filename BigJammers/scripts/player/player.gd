extends CharacterBody2D
class_name Player

signal jump_started
signal level_win

@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var heartbeat : HeartBeat = $Heartbeat
@onready var camera_2d: ShakeCamera2D = $Camera2D
@onready var feels: AnimatedSprite2D = $Feels

@export var HEARTBEAT_TIME := 30.0
@export var MOVEMENTSPEED = 100 # was = 5
@export var DAMPING = 45 # was = 5
@export var GRAVITY = 5 #was = 2
@export var FALL_GRAVITY_MULTIPLIER: float = 2
@export var JUMPBUFFERTIME : float = 0.3
@export var JUMPVELOCITY : float = 150 # was 50
@export var COYOTETIME : float = 0.3


var motion: Vector2 = Vector2.ZERO
var jumping : bool = false
var was_on_floor : bool = false
var gravity: Vector3 = Vector3.DOWN
var moving := true

# Powerup controls
var can_jump := true


func _ready():
	Events.level_win.connect(_on_level_win)
	heartbeat.init(HEARTBEAT_TIME)

func _process(_delta):
	#_flip_sprite()
	pass

# Call on level ready on level start, and on level start when animation of 
# start level is complete
func on_level_ready():
	moving = false

# Give specific time
func on_level_start(_time: float):
	moving = true

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

func _movement(_delta: float):
	var movement : Vector2 = InputManager.get_movement()
	motion.x += movement.x * MOVEMENTSPEED

func _drag(delta: float) -> void:
	var damping = _get_damping()
	motion.x *= 1.0 / (1.0 + delta * damping)

func _get_damping() -> float:
	return DAMPING
	# return PhysicsServer2D.body_get_direct_state(get_rid()).total_linear_damp
	
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
			if Input.is_action_pressed(InputManager.jump_input):
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
	if not can_jump:
		return
	jump_started.emit()
	jumping = true
	motion.y = -abs(JUMPVELOCITY)

func _gravity(_delta: float):
	var gravity_multiplier : float = 1.0 if jumping else FALL_GRAVITY_MULTIPLIER
	motion.y += GRAVITY * gravity_multiplier
	motion.y = min(motion.y, 2000.0)

func kill():
	heartbeat.kill()

@onready var jail_cell = $JailCell
func _on_level_win() -> void:
	# horrible but speed
	feels.animation = &"ecstatic"
	level_win.emit()
	if jail_cell.get_child(0) is AnimationPlayer:
		jail_cell.get_child(0).play("unlock")
