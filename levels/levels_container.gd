extends Node2D

@onready var smooth_transition_color: ColorRect = $ParallaxBackground/smooth_transition_color

var levels = [
	"res://levels/home_level.tscn",
	"res://levels/level1.tscn",
	"res://levels/level2.tscn",
	"res://levels/level3.tscn",
	"res://levels/level4.tscn",
	"res://levels/level5.tscn",
	"res://levels/level6.tscn",
	"res://levels/level7.tscn",
	"res://levels/level8.tscn",
	"res://levels/level9.tscn",
	"res://levels/level10.tscn",
	"res://levels/level11.tscn",
	"res://levels/level12.tscn",
]

var current_level_scene: Node = null
#@export var starting_level: int = 0

func _ready() -> void:
	smooth_transition_color.visible = true
	Global.level_completed.connect(on_level_completed)
	Global.restart_level.connect(on_restart_level)
	Global.go_to_level.connect(on_go_to_level)
	Global.gem_collected.connect(on_gem_collected)

	smooth_transition_color.modulate.a = 1.0
	loadLevel(levels[Global.current_level]) 

	# Fade in at the start
	var tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func loadLevel(level_path: String) -> void:
	if current_level_scene:
		current_level_scene.queue_free()  # Ensure old level is removed before loading a new one

	current_level_scene = load(level_path).instantiate()
	add_child(current_level_scene)  # Add the new level

func fadeOutAndChangeLevel(level: String) -> void:
	
	var tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 1.0, 1.0
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	loadLevel(level)

	# Fade back in after loading
	tween = get_tree().create_tween()
	tween.tween_property(smooth_transition_color, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func on_level_completed() -> void:
	await get_tree().create_timer(.3).timeout
	#if(Global.current_level == 12):
	
	#print(gems_collected)
	#Global.current_level += 1
	#fadeOutAndChangeLevel(Global.current_level)

	if(Global.current_level + 1 > Global.lastUnlockedLevel):
		Global.setLastUnlockedLevel(Global.current_level + 1)
	set_current_level_scene(0)
	fadeOutAndChangeLevel(levels[Global.current_level])

func on_restart_level():
	fadeOutAndChangeLevel(levels[Global.current_level])


func on_go_to_level(levelNumber: int):
	set_current_level_scene(levelNumber)
	fadeOutAndChangeLevel(levels[levelNumber])


func on_gem_collected(gem: String):
	Global.addCollectedGem(Global.current_level, gem)
	#Global.collectedGems[Global.current_level - 1].push_front(gem)


func set_current_level_scene(val: int):
	Global.current_level = val
	Global.current_level = val
