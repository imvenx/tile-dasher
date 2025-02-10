extends Node

@warning_ignore("unused_signal")
signal level_completed

@warning_ignore("unused_signal")
signal restart_level

@warning_ignore("unused_signal")
signal go_to_level(level_number: int)

@warning_ignore("unused_signal")
signal gem_collected(name: String)

var default_collected_gems = [
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
]

@onready var collected_gems: Array = getItem('collected_gems', default_collected_gems)
func set_collected_gems(level: int, gem: String):
	collected_gems[level - 1].push_front(gem)
	setItem('collected_gems', collected_gems)


@onready var last_unlocked_level = getItem('last_unlocked_level', 1)
func set_last_unlocked_level(val: int):
	last_unlocked_level = val
	setItem('last_unlocked_level', val)
	#save("last_unlocked_level", val)
	

var current_level = 0

func _ready():
	var path = "user://save.json"

	#setItem('w', 'waa')
	print(getItem('w'))
	#var q = getItem('last_unlocked_level', 1)
	#print(q)
	#s('aa', 'aa')
	#print(l('aa'))
	# Save data
	#var data_to_save = {"asd": "hello world"}
	#var file = FileAccess.open(path, FileAccess.WRITE)
	#file.store_string(JSON.stringify(data_to_save))
	#file.close()

	# Load data
	#if FileAccess.file_exists(path):
		#var _file = FileAccess.open(path, FileAccess.READ)
		#var loaded_data = JSON.parse_string(_file.get_as_text())
		#_file.close()
		#print(loaded_data.get("asd", "default_value"))  # Should print: "hello world"

var path = "user://save.json"

func setItem(key: String, val):
	# Load existing data to avoid overwriting other keys
	var data_to_save = {}

	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		data_to_save = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()

	# Update or add the new value
	data_to_save[key] = val

	# Save the updated data back to the file
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data_to_save))
	file.close()

func getItem(key: String, default_value = null):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var loaded_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()
		return loaded_data.get(key, default_value)

	return default_value


func deleteAllStorage():
	# Delete the save file if it exists
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("All saved data deleted.")

	# Reset in-memory values (optional)
	#collected_gems = default_collected_gems.duplicate(true)
	#last_unlocked_level = 1

	# Re-save defaults to prevent errors when reloading the game
	setItem("collected_gems", null)
	setItem("last_unlocked_level", null)
