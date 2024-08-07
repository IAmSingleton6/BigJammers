extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var static_body_2d = $StaticBody2D
@onready var collision_shape_2d = $CollisionShape2D

@export var steam_particle_scene: PackedScene



func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.WATERGROUP):
		_solidify()
	if other.is_in_group(GroupManager.ICEGROUP):
		_solidify()


# Change sprite + make solid with sprite + smoke particles
func _solidify():
	collision_shape_2d.reparent(static_body_2d)
	var steam = steam_particle_scene.instantiate()
	get_tree().root.add_child(steam)
	steam.global_position = global_position
	animation_player.play("solidify")
