extends Node2D

@onready var smooth_transition_color: ColorRect = $smooth_transition_color

var levels = [
	"res://levels/level1.tscn",
	"res://levels/level2.tscn",
	"res://levels/level3.tscn",
	"res://levels/level4.tscn",
	"res://levels/level5.tscn",
	"res://levels/level6.tscn",
	"res://levels/level7.tscn",
]

var current_level: Node = null
@export var level_index: int = 0

func _ready() -> void:
	smooth_transition_color.visible = true
	GlobalEvents.level_completed.connect(on_level_completed)  # Ensure we're listening for the level completion event
	GlobalEvents.restart_level.connect(on_restart_level)  # Ensure we're listening for the level completion event

	smooth_transition_color.modulate.a = 1.0  # Start fully visible
	_load_level(levels[level_index])  # Load first level

	# Fade in at the start
	var tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _load_level(level_path: String) -> void:
	if current_level:
		current_level.queue_free()  # Ensure old level is removed before loading a new one

	current_level = load(level_path).instantiate()
	add_child(current_level)  # Add the new level

func fade_out_and_change_level(level:int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 1.0, 1.0
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	if level_index >= levels.size():
		print('game finished')
		return
		
	if level_index < levels.size():
		_load_level(levels[level_index])

	# Fade back in after loading
	tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func on_level_completed() -> void:
	level_index += 1
	fade_out_and_change_level(level_index)

func on_restart_level():
	fade_out_and_change_level(level_index)
	#_load_level(levels[level_index])
