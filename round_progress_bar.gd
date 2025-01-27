extends Node2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@export var obj: Node

func _process(delta: float) -> void:
	var progress = obj.get_progress()
	if(progress >= 100):
		visible = false
		return
		
	visible = true
	progress_bar.value = progress
