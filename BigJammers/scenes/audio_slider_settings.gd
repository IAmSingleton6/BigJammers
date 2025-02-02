extends Control

static var BUSVOLUMEUNIQUENAME = "BusVolume"

@onready var audio_name_label = $HBoxContainer/Audio_Name_Label as Label
@onready var audio_num_label = $HBoxContainer/Audio_Num_Label as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	set_audio_name_label_text()
	set_slider_value()

func set_audio_name_label_text():
	audio_name_label.text = str(bus_name) + " Volume"
	
func set_audio_num_label_text():
	audio_num_label.text = str(h_slider.value * 100) + "%"
	
func get_bus_name_by_index():
	bus_index = AudioServer.get_bus_index(bus_name)
	
func set_slider_value():
	var save_data = SaveSystem.load_data(BUSVOLUMEUNIQUENAME)
	var value = save_data[bus_name] if save_data.has(bus_name) \
		else db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	h_slider.value = value
	set_audio_num_label_text()
	
func on_value_changed(value: float) -> void:
	var volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume)
	set_audio_num_label_text()
	
	var save_data = SaveSystem.load_data(BUSVOLUMEUNIQUENAME)
	save_data[bus_name] = volume
	SaveSystem.save_data(BUSVOLUMEUNIQUENAME, save_data)
