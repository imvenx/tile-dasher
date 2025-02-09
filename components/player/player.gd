extends CharacterBody2D
class_name Player

@onready var floor_detector:FloorDetector = $floor_detector
@onready var fall_behaviour: FallBehaviour = $fall_behaviour
@onready var dash_behaviour: DashBehaviour = $dash_behaviour
@onready var move_8d_behaviour: Move8DBehaviour = $move_8d_behaviour
@onready var rotate_behaviour: RotateBehaviour = $rotate_behaviour
@onready var dash_sound: AudioStreamPlayer2D = $dash_behaviour/dash_sound
@onready var state_machine: StateMachine = $state_machine
@onready var dash_progress_bar = $'../dash_progress_bar'
@onready var area_2d = $Area2D
var anim_speed = 1

func _ready() -> void:
	#state_machine.change_state('fall')
	
	floor_detector.connect('fallen', on_fall)
	fall_behaviour.connect('ended_falling', on_ended_falling)
	dash_behaviour.connect('dash', on_dash)
	move_8d_behaviour.connect('started_moving', on_start_moving)
	move_8d_behaviour.connect('stoped_moving', on_stop_moving)
	area_2d.connect("area_entered", on_area_entered)
	state_machine.connect("anim_ended", on_anim_ended)
	

func _process(delta: float) -> void:
	
	if(fall_behaviour.is_falling):	return
	handle_movement_and_rotation()

func handle_movement_and_rotation():
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
	
func _input(event: InputEvent):
			
	if not floor_detector.has_fallen:
		if event.is_action_pressed('dash'):
			if state_machine.state == 'walk':
				state_machine.change_anim_speed(0.5)
			dash_behaviour.start_dashing()
			rotate_behaviour.modify_rotation_speed(4)
			move_8d_behaviour.change_speed(.5)
		if event.is_action_released('dash'):
			state_machine.change_anim_speed(anim_speed)
			dash_behaviour.stop_dashing()
			rotate_behaviour.reset_rotation_speed()
			move_8d_behaviour.reset_speed()
	
func on_fall():
	$gems.visible = false
	floor_detector.disconnect('fallen', on_fall)
	state_machine.disconnect("anim_ended", on_anim_ended)
	move_8d_behaviour.disconnect('stoped_moving', on_stop_moving)
	fall_behaviour.start_falling()
	dash_behaviour.cancel_dash()
	dash_progress_bar.set_is_visible(false)
	move_8d_behaviour.stop_moving()
	state_machine.change_state('fall')

func on_dash(dash_position: Vector2) -> void:
	dash_sound.play()
	global_position = dash_position

func on_ended_falling():
	Global.restart_level.emit()

func on_start_moving():
	state_machine.change_state('walk')
	#move_8d_behaviour.change_speed(1.1)
	
func on_stop_moving():
	state_machine.change_state('idle')


var gems = 0
func on_area_entered(area2d: Area2D):
	if area2d.is_in_group("gem"):
		gems += 1
		Global.gem_collected.emit(area2d.name)
		state_machine.change_state('happy')
		if(gems == 3):
			state_machine.change_state('happy')
			#state_machine.change_state('run_scared')
			anim_speed += .1
			move_8d_behaviour.change_speed(anim_speed)
			state_machine.change_anim_speed(anim_speed)
		
		await get_tree().create_timer(.2).timeout
		get_node('gems/' + area2d.name).visible = true
		(get_node('../hud/' + area2d.name) as Sprite2D
		).modulate = Color(1,1,1,1)
	
	if area2d.name == "blink_bracer":
		state_machine.change_state('happy')
		$"pick-item".play()
		await get_tree().create_timer(.1).timeout
		get_tree().paused = true
		$"pick-item".process_mode = Node.PROCESS_MODE_ALWAYS
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		
		
		
func on_anim_ended(anim: String):
	if(anim == 'happy'):
		if gems == 3:
			state_machine.change_state('run_scared')
		else:
			state_machine.change_state('walk')
		
	
