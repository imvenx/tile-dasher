extends Node2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@export var obj: Node
var _is_visible = true

func _process(delta: float) -> void:
	
	if not _is_visible: return
	
	var progress = obj.get_progress()
	if(progress >= 100):
		visible = false
		return
		
	visible = true
	progress_bar.value = progress


func set_is_visible(__is_visible:bool):
	_is_visible = __is_visible
	visible = _is_visible
