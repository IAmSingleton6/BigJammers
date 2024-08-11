extends Node

@export var drum_volume_seek_speed := 7
@export var minimum_drum_volume := 20.0

@onready var intro: AudioStreamPlayer = $intro
@onready var drums: AudioStreamPlayer = $drums
@onready var background: AudioStreamPlayer = $background

var start_drums_volume := 0.0
var drums_volume_01 := 0.0 : set = set_drums_volume_01


func _ready():
	start_drums_volume = drums.volume_db
	_start_music()

func _process(delta):
	var drum_vol_target = lerp(-abs(minimum_drum_volume), start_drums_volume, drums_volume_01)
	drums.volume_db = lerp(drums.volume_db, drum_vol_target, delta * drum_volume_seek_speed)


func _start_music():
	intro.play()
	# time in seconds of 4 bars at 95bpm + offset for some reason hahahahhha
	await get_tree().create_timer(2.5263 * 4 + 0.2).timeout
	drums.play()
	background.play()


func set_drums_volume_01(vol: float) -> void:
	drums_volume_01 = vol


var pause_tween: Tween

func on_pause_start() -> void:
	# get low pass effect
	print("music pause start")
	pause_tween = get_tree().create_tween()
	pause_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	pause_tween.tween_property(drums, "pitch_scale", 0.9, 1)
	pause_tween.tween_property(background, "pitch_scale", 0.9, 1)
	pause_tween.tween_property(drums, "volume_db", -5, 1)
	pause_tween.tween_property(background, "volume_db", -5, 1)
	pause_tween.play()


func on_pause_end():
	# get low pass effect
	print("music pause end")
	pause_tween = get_tree().create_tween()
	pause_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	pause_tween.tween_property(drums, "pitch_scale", 1, 1)
	pause_tween.tween_property(background, "pitch_scale", 1, 1)
	pause_tween.tween_property(drums, "volume_db", 0, 1)
	pause_tween.tween_property(background, "volume_db", 0, 1)
	pause_tween.play()
