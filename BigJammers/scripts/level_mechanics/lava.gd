extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var static_body_2d = $StaticBody2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Lava_anim
@onready var solid_block_sprite = $SolidBlockSprite

@export var steam_particle_scene: PackedScene


func _ready():
	sprite_2d.visible = true
	solid_block_sprite.visible = false
	area_entered.connect(_on_area_entered)


func _on_area_entered(other):
	if other.is_in_group(GroupManager.WATERGROUP):
		if other.get_parent() is Block:
			other.get_parent().destroy_block(GroupManager.FIREGROUP)
			call_deferred("_solidify")
	if other.is_in_group(GroupManager.ICEGROUP):
		if other.get_parent() is Block:
			other.get_parent().destroy_block(GroupManager.FIREGROUP)
			call_deferred("_solidify")
	if other.is_in_group(GroupManager.STICKYBLOCK):
		if other.get_parent() is Block:
			other.get_parent().destroy_block(GroupManager.FIREGROUP)


# Change sprite + make solid with sprite + smoke particles
func _solidify():
	collision_shape_2d.reparent(static_body_2d)
	var steam = steam_particle_scene.instantiate()
	get_tree().root.add_child(steam)
	
	steam.global_position = global_position
	sprite_2d.visible = false
	solid_block_sprite.visible = true
	
	animation_player.play("solidify")
