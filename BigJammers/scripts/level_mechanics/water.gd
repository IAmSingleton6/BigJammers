extends Area2D
class_name Water

@onready var sprite_2d = $Sprite2D
@onready var solid_block_sprite = $SolidBlockSprite
@onready var static_body_2d = $StaticBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer

@export var steam_particle_scene: PackedScene


func _ready():
	sprite_2d.visible = true
	solid_block_sprite.visible = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(other):
	if other.is_in_group(GroupManager.FIREGROUP):
		if other.get_parent() is Block:
			other.get_parent().destroy_block(GroupManager.WATERGROUP)
			print("water evaporates from fire block")
			destroy()
	if other.is_in_group(GroupManager.ICEGROUP):
		if other.get_parent() is Block:
			print("water freezes over from ice block")
			other.get_parent().destroy_block(GroupManager.WATERGROUP)
			_freeze()


func _freeze():
	collision_shape_2d.reparent(static_body_2d)
	var steam = steam_particle_scene.instantiate()
	get_tree().root.add_child(steam)
	steam.global_position = global_position
	sprite_2d.visible = false
	solid_block_sprite.visible = true
	animation_player.play("solidify")


func destroy():
	queue_free()
