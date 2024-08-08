extends Node
const DEBUG_DISABLE: bool = true

# TODO: Pass the whole system through an encryption algorithm
# That will scramble and unscramble the JSON

# CAVEAT
# All dictionaries saved will have their keys converted to strings
# EG dictionary { 1 : 0 } -> { "1" -> 0 }

# To use in a script
#   SaveSystem.save_data(SaveDataContainer.new(unique_name, Dictionary))
#   var data := SaveSystem.load_data(unique_name)

# var health = 5
# var SAVEUNIQUENAME = "Player"
# eg var player_data = SaveSystem.load_data(SAVEUNIQUENAME)
# health = player_data["health"]
#
# eg SaveSystem.save_data(SAVEUNIQUENAME, {"health": health})
#
# SaveSystem.save_all_data()

var path : String = "user://save.json"
var data : Dictionary = {}


# Called before all other nodes so they can access save_data in _ready()
func _init() -> void:
	if DEBUG_DISABLE:
		print("SaveSystem is disabled in debug mode. Changes will not persist.")
		return
	data = _load_data_from_file()


# Access loaded JSON data via a unique name 
func load_data(unique_identifier: String) -> Dictionary:
	if not data.has(unique_identifier):
		return {}
	return data[unique_identifier] 


# Save all changed data
func save_all_data() -> void:
	if DEBUG_DISABLE:
		return
	print("Saving data to JSON")
	
	var file := _open_file(FileAccess.WRITE)
	var data_string := JSON.stringify(data)
	var encrypted_data_string := JSONEncryptor.encrypt(data_string)
	file.store_string(encrypted_data_string)
	file.close()
	
	print("Saving from JSON complete!")


func save_data(unique_name: String, new_data: Dictionary) -> void:
	data[unique_name] = new_data


func clear_save_data() -> void:
	var file := _open_file(FileAccess.WRITE)
	file.store_string("")
	file.close()
	print("Wiped save data!")

# Private

func _load_data_from_file() -> Dictionary:
	print("Loading data from JSON")
	if not FileAccess.file_exists(path):
		return {}
	var file = _open_file(FileAccess.READ)
	
	var data_string_encrypted := file.get_as_text()
	if file.get_as_text().is_empty():
		print("No saved data to load")
		return {}
	var data_string_unencrypted := JSONEncryptor.unencrypt(data_string_encrypted)
	var parsed_data = JSON.parse_string(data_string_unencrypted)
	
	file.close()
	
	if parsed_data is Dictionary:
		print("Loading data from JSON complete!")
		return parsed_data
	else:
		push_error("Save data is not a dictionary")
		return {}



# TODO: Could add a password with encryption
func _open_file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(path, access)


class JSONEncryptor:
	static func encrypt(data) -> String:
		return data
	
	
	static func unencrypt(data) -> String:
		return data
