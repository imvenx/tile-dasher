extends Node

@warning_ignore("unused_signal")
signal level_completed

@warning_ignore("unused_signal")
signal restart_level

@warning_ignore("unused_signal")
signal go_to_level(level_number: int)

@warning_ignore("unused_signal")
signal gem_collected(name: String)

@warning_ignore("unused_signal")
signal blinkBracerPicked

var hasBlinkBracer = getItem('hasBlinkBracer', false)

var defaultCollectedGems = [
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
]

@onready var collected_gems: Array = getItem('collected_gems', defaultCollectedGems)
func set_collected_gems(level: int, gem: String):
	collected_gems[level - 1].push_front(gem)
	setItem('collected_gems', collected_gems)

var defaultUnlockedLevel = 1
@onready var last_unlocked_level = getItem('last_unlocked_level', defaultUnlockedLevel)
func set_last_unlocked_level(val: int):
	last_unlocked_level = val
	setItem('last_unlocked_level', val)
	#save("last_unlocked_level", val)
	

var current_level = 0

func _ready():
	blinkBracerPicked.connect(
		func(): 
			hasBlinkBracer = true
			setItem('hasBlinkBracer', true)
			)
	#deleteAllStorage()
	pass

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
	if FileAccess.file_exists('user://save.json'):
		var file = FileAccess.open('user://save.json', FileAccess.READ)
		var loaded_data = JSON.parse_string(file.get_as_text()) as Dictionary
		file.close()
		return loaded_data.get(key, default_value)

	return default_value


func deleteAllStorage():
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
