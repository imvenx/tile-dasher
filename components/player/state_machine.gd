extends Node2D
class_name StateMachine

@export var anim_tree: AnimationTree
var state: String
signal anim_ended(anim: String)
var anim_speed = 1
#var reset_anim_speed_val = anim_speed

func _ready() -> void:
	anim_tree.connect('animation_finished', on_animation_finished)
	show_only_first_anim()
	
func show_only_first_anim():
	var i = 0
	for child in get_children():
		if i == 0: 
			state = child.name
			child.visible = true
		else:
			child.visible = false
		
		i += 1


func change_state(new_state: String):
	get_node(state).visible = false
	get_node(new_state).visible = true
	#anim_tree.set("parameters/StateMachine/conditions/" + state, false)
	#anim_tree.set("parameters/StateMachine/conditions/" + new_state, true)
	state = new_state

func change_anim_speed(speed: float):
	#reset_anim_speed_val = anim_speed
	anim_speed = speed
	anim_tree.set('parameters/TimeScale/scale', anim_speed)
	
#func reset_anim_speed():
	#anim_speed = reset_anim_speed_val
	#anim_tree.set('parameters/TimeScale/scale', anim_speed)

func on_animation_finished(anim: String):
	anim_ended.emit(anim)
	
