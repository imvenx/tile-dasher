extends Node2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@export var obj: Node
var is_visible = true

func _process(delta: float) -> void:
	
	if not is_visible: return
	
	var progress = obj.get_progress()
	if(progress >= 100):
		visible = false
		return
		
	visible = true
	progress_bar.value = progress


func set_is_visible(_is_visible:bool):
	is_visible = _is_visible
	visible = is_visible
