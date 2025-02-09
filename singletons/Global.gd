extends Node

@warning_ignore("unused_signal")
signal level_completed

@warning_ignore("unused_signal")
signal restart_level

@warning_ignore("unused_signal")
signal go_to_level(level_number: int)

@warning_ignore("unused_signal")
signal gem_collected(name: String)

var collected_gems: Array = [
	['gem1'], [], [], [], [], [], [], [], [], [], [], [], [], [],
	[], [], [], [], [], [], [], [], [], [], [], [], [], [],
]

var last_unlocked_level = 1
