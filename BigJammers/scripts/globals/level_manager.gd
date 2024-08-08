extends Node

var _current_level: LevelData


func set_current_level(level: LevelData) -> void:
	_current_level = level


func get_current_level() -> LevelData:
	return _current_level


func set_current_level_completed():
	if not _current_level:
		print("No current level to set to complete")
		return
	
	var current_save_data = SaveSystem.load_data(LevelData.LEVELSAVEUNIQUENAME)
	if not current_save_data.has(_current_level.level_name):
		current_save_data[_current_level.level_name] = {
			"completed": false,
		}
	current_save_data[_current_level.level_name]["completed"] = true
	SaveSystem.save_data(LevelData.LEVELSAVEUNIQUENAME, current_save_data)
