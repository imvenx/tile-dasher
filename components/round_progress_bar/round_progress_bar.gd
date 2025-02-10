extends Node2D
class_name DashProgressBar

@onready var progress_bar: Sprite2D = $sprite
@export var obj: Node
var isVisible = true

const FRAME_COUNT = 17 


func _process(delta: float) -> void:
	if not isVisible: return

	var progress = obj.getProgress()
	
	if progress >= 100:
		visible = false
		return

	visible = true

	var frame_index = int((1.0 - (progress / 100.0)) * (FRAME_COUNT - 1))
	progress_bar.frame = frame_index


func setIsVisible(_isVisible: bool):
	isVisible = _isVisible
	visible = isVisible
