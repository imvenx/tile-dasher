extends Node2D

@export var start_state = 'idle'
var current_state = start_state
#var anims = ['idle', 'walk', 'attack']

func _ready() -> void:
	
	var i = 0
	for child in get_children():
		if i == 0: return
		i += 1
		child.visible = false
		
		#get_node("animations/" + anim.name).visible = false
