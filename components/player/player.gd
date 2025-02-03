extends CharacterBody2D
class_name Player

@onready var floor_detector:FloorDetector = $floor_detector
@onready var fall_behaviour: FallBehaviour = $fall_behaviour
@onready var dash_behaviour: DashBehaviour = $dash_behaviour
@onready var move_8d_behaviour: Move8DBehaviour = $move_8d_behaviour
@onready var rotate_behaviour: RotateBehaviour = $rotate_behaviour
@onready var dash_sound: AudioStreamPlayer2D = $dash_behaviour/dash_sound

func _ready() -> void:
	floor_detector.connect('fallen', on_fall)
	fall_behaviour.connect('ended_falling', on_ended_falling)
	dash_behaviour.connect('dash', _on_dash_behaviour_dash)
	move_8d_behaviour.connect('started_moving', on_start_moving)
	move_8d_behaviour.connect('stoped_moving', on_stop_moving)


func _process(delta: float) -> void:
	#$AnimationTree.set("parameters/TimeScale/scale", 0.1)
	#var t = $AnimationTree.get("parameters/playback")
	
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
	move_8d_behaviour.move_8d(input_vector)
	rotate_behaviour.rotate(input_vector)
	
	#if Input.is_action_pressed('dash'):
		#if not floor_detector.has_fallen:
			#dash_behaviour.start_dashing()
			#rotate_behaviour.modify_rotation_speed(4)
			#move_8d_behaviour.modify_speed(10)


func _input(event: InputEvent):
			
	if not floor_detector.has_fallen:
		if event.is_action_pressed('dash'):
			if $AnimationTree.get('parameters/StateMachine/playback').get_current_node() == 'walk':
				$AnimationTree.set('parameters/TimeScale/scale', 0.3)
			dash_behaviour.start_dashing()
			rotate_behaviour.modify_rotation_speed(4)
			move_8d_behaviour.modify_speed(10)
		if event.is_action_released('dash'):
			$AnimationTree.set('parameters/TimeScale/scale', 1)
			dash_behaviour.stop_dashing()
			rotate_behaviour.reset_rotation_speed()
			move_8d_behaviour.reset_speed()
	
		#print("Key K was pressed for the first time!")
		#if event is InputEventKey:
			#if (event as InputEvent).keycode == KEY_K:
				#if event.pressed:
			#print('asd')
		
		
func on_fall():
	fall_behaviour.start_falling()
	dash_behaviour.cancel_dash()
	$'../dash_progress_bar'.set_is_visible(false)
	move_8d_behaviour.stop_moving()
	move_8d_behaviour.disconnect('stoped_moving', on_stop_moving)
	$state_machine/idle.visible = false
	$state_machine/walk.visible = false
	$state_machine/fall.visible = true
	$AnimationTree.set("parameters/StateMachine/conditions/is_idle", false)
	$AnimationTree.set("parameters/StateMachine/conditions/is_walking", false)
	$AnimationTree.set("parameters/StateMachine/conditions/is_falling", true)


func _on_dash_behaviour_dash(dash_position: Vector2) -> void:
	dash_sound.play()
	position = dash_position


func on_ended_falling():
	print('player ended falling')
	reset_scene()


func reset_scene():
	GlobalEvents.restart_level.emit()
	
func on_start_moving():
	$state_machine/idle.visible = false
	$state_machine/walk.visible = true
	$AnimationTree.set("parameters/StateMachine/conditions/is_idle", false)
	$AnimationTree.set("parameters/StateMachine/conditions/is_walking", true)

func on_stop_moving():
	$state_machine/idle.visible = true
	$state_machine/walk.visible = false
	$AnimationTree.set("parameters/StateMachine/conditions/is_idle", true)
	$AnimationTree.set("parameters/StateMachine/conditions/is_walking", false)
