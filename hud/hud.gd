extends CanvasLayer

func _ready() -> void:
	var gems = Global.collected_gems[Global.current_level - 1]
	for gem in gems:
		get_node(gem).modulate = Color(1,1,1,1)
