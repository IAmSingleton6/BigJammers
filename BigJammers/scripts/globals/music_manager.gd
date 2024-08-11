extends Node

@export var drum_volume_seek_speed := 3
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


var lpf_pause_tween: Tween
func on_pause_start() -> void:
	# get low pass effect
	var effect = AudioServer.get_bus_effect(1, 0)
	if effect:
		lpf_pause_tween = get_tree().create_tween()
		lpf_pause_tween.tween_property(effect, "cutoff_hz", 400, 1)
		lpf_pause_tween.play()


func on_pause_end():
	# get low pass effect
	var effect = AudioServer.get_bus_effect(1, 0)
	if effect:
		lpf_pause_tween = get_tree().create_tween()
		lpf_pause_tween.tween_property(effect, "cutoff_hz", 10000, 1)
		lpf_pause_tween.play()
	
