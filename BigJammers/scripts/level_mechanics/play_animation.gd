extends AnimationPlayer
@export var animation_name: StringName 

func play_anim():
	play(animation_name)
	
