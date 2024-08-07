class_name InputManager

static var jump_input = "Jump"
static var move_right = "MoveRight"
static var move_left = "MoveLeft"
static var move_up = "MoveUp"
static var move_down = "MoveDown"
static var restart_level = "RestartLevel"


static func get_movement() -> Vector2:
	var x: float = Input.get_axis("MoveLeft", "MoveRight")
	var y: float = Input.get_axis("MoveDown", "MoveUp")
	return Vector2(x, y)
