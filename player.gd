extends CharacterBody2D
class_name Player

@onready var floor_detector:FloorDetector = $floor_detector
@onready var fall_behaviour: FallBehaviour = $fall_behaviour
@onready var dash_behaviour: DashBehaviour = $dash_behaviour
@onready var move_8d_hevariour: Move8DBehaviour = $move_8d_behaviour

func _ready() -> void:
	floor_detector.connect('fallen', on_fall)
	fall_behaviour.connect('ended_falling', on_ended_falling)
	dash_behaviour.connect('dash', _on_dash_behaviour_dash)

func _process(delta: float) -> void:
	
	if(fall_behaviour.is_falling):	return
	
	## MOVE
	var input_vector = Vector2.ZERO
	if Input.is_key_pressed(KEY_W):
		input_vector.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_vector.x += 1
	move_8d_hevariour.move_8d(input_vector, delta)
		
	### DASH
	#if Input.is_key_pressed(KEY_K):
		#if not dash_behaviour.is_dashing: dash_behaviour.start_dashing()
	#else:
		#if dash_behaviour.is_dashing: dash_behaviour.stop_dashing()

func _input(event: InputEvent):
	
	if not floor_detector.has_fallen:
		if event is InputEventKey:
			if (event as InputEvent).keycode == KEY_K:
				if event.pressed:
					dash_behaviour.start_dashing()
					move_8d_hevariour.modify_rotation_speed(4)
				else:
					dash_behaviour.stop_dashing()
					move_8d_hevariour.reset_rotation_speed()
				
func on_fall():
	fall_behaviour.start_falling()
	dash_behaviour.cancel_dash()


func _on_dash_behaviour_dash(dash_position: Vector2) -> void:
	position = dash_position


func on_ended_falling():
	print('player ended falling')
	reset_scene()


func reset_scene():
	get_tree().reload_current_scene()
