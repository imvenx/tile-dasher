extends CanvasLayer

func _ready() -> void:
	Global.go_to_level.connect(onGoToLevel)
	#$gem1.modulate = Color(1,1,1,1)
	var gems = Global.collected_gems[Global.current_level - 1]
	for gem in gems:
		get_node(gem).modulate = Color(1,1,1,1)

func onGoToLevel(levelNumber: int):
	#await get_tree().create_timer(1).timeout
	#$gem1.modulate = Color(1,1,1,1)
	print('asd')
	#
