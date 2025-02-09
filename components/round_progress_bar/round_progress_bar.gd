extends Node2D

@onready var progress_bar: Sprite2D = $sprite
@export var obj: Node
var _is_visible = true

const FRAME_COUNT = 17 


func _process(delta: float) -> void:
	if not _is_visible: return

	var progress = obj.get_progress()
	
	if progress >= 100:
		visible = false
		return

	visible = true

	var frame_index = int((1.0 - (progress / 100.0)) * (FRAME_COUNT - 1))
	progress_bar.frame = frame_index


func set_is_visible(__is_visible: bool):
	_is_visible = __is_visible
	visible = _is_visible
