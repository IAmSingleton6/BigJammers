extends Area2D
class_name SadPickup

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@export var pickup_smoke: PackedScene
# Could add timer to the effect?

func _ready() -> void:
	body_entered.connect(_on_player_entered)


func _on_player_entered(other) -> void:
	if other.is_in_group(GroupManager.PLAYERGROUP):
		(other as Player).can_jump = false
		audio_stream_player_2d.reparent(get_parent().get_parent())
		await get_tree().process_frame
		audio_stream_player_2d.global_position = global_position
		audio_stream_player_2d.play()
		var smoke = pickup_smoke.instantiate()
		get_tree().root.add_child(smoke)
		
		_disable_pickup()


func _disable_pickup():
	queue_free()
