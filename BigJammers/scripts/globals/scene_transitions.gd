extends CanvasLayer

@onready var animation_player = $AnimationPlayer

enum TransitionType {
	NONE,
	FADE,
	SWIPE
}

func change_scene_path(next_scene, transition_type: TransitionType = TransitionType.SWIPE) -> void:
	if next_scene is String:
		if not ResourceLoader.exists(next_scene):
			push_warning("Scene at path does not exist so will not switch scene: %s" % next_scene)
			return
	
	await play_transition(transition_type)
	if next_scene is String:
		get_tree().change_scene_to_file(next_scene)
	elif next_scene is PackedScene:
		get_tree().change_scene_to_packed(next_scene)


func restart_scene(transition_type: TransitionType = TransitionType.SWIPE) -> void:
	await play_transition(transition_type)
	get_tree().reload_current_scene()


func play_transition(transition_type: TransitionType) -> void:
	var transition : String = TransitionType.find_key(transition_type)
	transition = "NONE" if (transition == null) else transition
	
	if transition != "NONE":
		animation_player.play(transition)
		await animation_player.animation_finished
		animation_player.play_backwards(transition)
