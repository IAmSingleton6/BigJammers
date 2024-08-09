extends Node
class_name ButtonAudioLinker

@export var root_path: NodePath

@onready var sounds = {
	&"UI_Click" : AudioStreamPlayer.new(),
	&"UI_Hover" : AudioStreamPlayer.new()
}

func _ready() -> void:
	assert (root_path != null, "Empty root path for UI sounds")
	
	for i in sounds.keys():
		sounds[i].stream = load("res://assets/audio/sfx/menu/" + str(i) + ".wav")
		sounds[i].bus = &"SFX"
		add_child(sounds[i])
	
	install_sounds(get_node(root_path))


func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect( func(): _ui_sfx_play(&"UI_Hover") )
			i.pressed.connect( func(): _ui_sfx_play(&"UI_Click") )
		
		install_sounds(i)


func _ui_sfx_play(sound: StringName) -> void:
	sounds[sound].play()
