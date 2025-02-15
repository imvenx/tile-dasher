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

var lastLevelPlayed = getItem('lastLevelPlayed', 1)
func setLastLevelPlayed(val: int):
	lastLevelPlayed = int(val)
	setItem('lastLevelPlayed', val)

var currentSuit = getItem('currentSuit', 'green')
func setCurrentSuit(val: String):
	currentSuit = val
	setItem('currentSuit', val)
var unlockedSuits = getItem('unlockedSuits', ['green', 'lava'])
func addUnlockedSuit(suit: String):
	if not unlockedSuits.has(suit):
		unlockedSuits.push_front(suit)
	setItem('unlockedSuits', unlockedSuits)

var defaultCollectedGems = [
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
]

@onready var collectedGems: Array = getItem('collectedGems', defaultCollectedGems)
func addCollectedGem(level: int, gem: String):
	if not collectedGems[level - 1].has(gem):
		collectedGems[level - 1].push_front(gem)
	setItem('collectedGems', collectedGems)

var defaultUnlockedLevel = 1
@onready var lastUnlockedLevel = getItem('lastUnlockedLevel', defaultUnlockedLevel)
func setLastUnlockedLevel(val: int):
	lastUnlockedLevel = val
	setItem('lastUnlockedLevel', val)
	#save("lastUnlockedLevel", val)
	

var current_level = 0

func _ready():
	#deleteAllStorage()
	blinkBracerPicked.connect(func(): 
			hasBlinkBracer = true
			setItem('hasBlinkBracer', true))

var path = "user://save.json"

func setItem(key: String, val):
	var data_to_save = {}

	if FileAccess.file_exists(path):
		var readFile = FileAccess.open(path, FileAccess.READ)
		data_to_save = JSON.parse_string(readFile.get_as_text()) as Dictionary
		readFile.close()

	data_to_save[key] = val

	var writeFile = FileAccess.open(path, FileAccess.WRITE)
	writeFile.store_string(JSON.stringify(data_to_save))
	writeFile.close()

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
		
static func coalesce(value, default_value):
	return value if value != null else default_value
