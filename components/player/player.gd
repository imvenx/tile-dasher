extends CharacterBody2D
class_name Player

@onready var floor_detector:FloorDetector = $floor_detector
@onready var fall_behaviour: FallBehaviour = $fall_behaviour
@onready var dashBehaviour: DashBehaviour = $dash_behaviour
@onready var move_8d_behaviour: Move8DBehaviour = $move_8d_behaviour
@onready var rotate_behaviour: RotateBehaviour = $rotate_behaviour
@onready var dash_sound: AudioStreamPlayer2D = $dash_behaviour/dash_sound
@onready var state_machine: StateMachine = $state_machine
@onready var dash_progress_bar: DashProgressBar = $'../dash_progress_bar'
@onready var area_2d = $Area2D
@onready var virtual_joystick = %joystick

var anim_speed = 1

var localCollectedGems = []

func _ready() -> void:

	changeSuit(Global.currentSuit)

	#state_machine.change_state('fall')
	
	floor_detector.connect('fallen', onFall)
	fall_behaviour.connect('ended_falling', on_ended_falling)
	dashBehaviour.connect('dash', on_dash)
	move_8d_behaviour.connect('started_moving', on_start_moving)
	move_8d_behaviour.connect('stoped_moving', on_stop_moving)
	area_2d.connect("area_entered", on_area_entered)
	state_machine.connect("anim_ended", on_anim_ended)
	Global.level_completed.connect(onLevelCompleted)
	
func onLevelCompleted():
	for gem in localCollectedGems:
		Global.gem_collected.emit(gem)
	

func _process(delta: float) -> void:
	
	if(fall_behaviour.is_falling):	return
	handle_movement_and_rotation()

func handle_movement_and_rotation():
	var input_vector = Vector2.ZERO
	
	if virtual_joystick and virtual_joystick.is_active:
		# Use joystick input
		input_vector = virtual_joystick.get_output_vector()
	else:
		#if Input.is_key_pressed(KEY_W):
		if Input.is_action_pressed("ui_up"):
			input_vector.y -= 1
		#if Input.is_key_pressed(KEY_S):
		if Input.is_action_pressed("ui_down"):
			input_vector.y += 1
		if Input.is_action_pressed("ui_left"):
		#if Input.is_key_pressed(KEY_A):
			input_vector.x -= 1
		if Input.is_action_pressed("ui_right"):
		#if Input.is_key_pressed(KEY_D):
			input_vector.x += 1
	move_8d_behaviour.move_8d(input_vector)
	rotate_behaviour.rotate(input_vector)
	
func _input(event: InputEvent):
	
	if not Global.hasBlinkBracer: return
	
	if not floor_detector.has_fallen:
		# Check for right side screen press (touch or mouse) - but NOT keyboard
		if (event is InputEventScreenTouch or (event is InputEventMouseButton and not event is InputEventKey)):
			if event.pressed and event.position.x > get_viewport_rect().size.x / 2:
				if state_machine.state == 'walk':
					state_machine.change_anim_speed(0.5)
				dashBehaviour.startDashing()
				rotate_behaviour.modify_rotation_speed(4)
				move_8d_behaviour.change_speed(.5)
			elif not event.pressed and event.position.x > get_viewport_rect().size.x / 2:
				state_machine.change_anim_speed(anim_speed)
				dashBehaviour.stopDashing()
				rotate_behaviour.reset_rotation_speed()
				move_8d_behaviour.reset_speed()
		
		# Keep existing keyboard functionality
		if event.is_action_pressed('dash'):
			if state_machine.state == 'walk':
				state_machine.change_anim_speed(0.5)
			dashBehaviour.startDashing()
			rotate_behaviour.modify_rotation_speed(4)
			move_8d_behaviour.change_speed(.5)
		if event.is_action_released('dash'):
			state_machine.change_anim_speed(anim_speed)
			dashBehaviour.stopDashing()
			rotate_behaviour.reset_rotation_speed()
			move_8d_behaviour.reset_speed()
			
func onFall():
	$CollisionShape2D.disabled = true
	z_index -= 3
	$gems.visible = false
	fall_behaviour.start_falling()
	floor_detector.disconnect('fallen', onFall)
	state_machine.disconnect("anim_ended", on_anim_ended)
	move_8d_behaviour.disconnect('stoped_moving', on_stop_moving)
	#dashBehaviour.cancelDash()
	dashBehaviour.queue_free()
	dash_progress_bar.setIsVisible(false)
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
		localCollectedGems.push_front(area2d.name)
		gems += 1
		state_machine.change_state('happy')
		$state_machine/happy/gem.visible = true
		$state_machine/happy/blink_bracer.visible = false
		if(gems == 3):
			#state_machine.change_state('happy')
			#state_machine.change_state('run_scared')
			anim_speed += .1
			move_8d_behaviour.change_speed(anim_speed)
			state_machine.change_anim_speed(anim_speed)
		
		await get_tree().create_timer(.2).timeout
		get_node('gems/' + area2d.name).visible = true
		(get_node('../hud/' + area2d.name) as Sprite2D
		).modulate = Color(1,1,1,1)
	
	if area2d.name == "blink_bracer":
		$"pick-item".process_mode = Node.PROCESS_MODE_ALWAYS
		$"pick-item".play()
		dash_progress_bar.setIsVisible(false)
		dashBehaviour.cancelDash()
		state_machine.change_state('happy')
		$state_machine/happy/gem.visible = false
		$state_machine/happy/blink_bracer.visible = true
		await get_tree().create_timer(.1).timeout
		get_tree().paused = true
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		dash_progress_bar.setIsVisible(true)
		
		
func on_anim_ended(anim: String):
	if(anim == 'happy'):
		if gems == 3:
			state_machine.change_state('run_scared')
		else:
			state_machine.change_state('walk')
	

func changeSuit(suit: String):
	
	$changeClothesParticles.set_emitting(true)
	var _material: ShaderMaterial = $state_machine/idle.material
	_material.set_shader_parameter('targetColor', Vector3(.5,.5,.5))
	_material.set_shader_parameter('replacementColor', Vector3(0,1,1))
	_material.set_shader_parameter('tolerance', 10)
	await get_tree().create_timer(.3).timeout
	
	_material.set_shader_parameter('isReplacementColorDisabled', false)
	modulate = Color(1,1,1,1)
	
	if(suit == 'green'):
		_material.set_shader_parameter('tolerance', 0)
	
	if(suit == 'orange'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(1,0.6,0.2))
		_material.set_shader_parameter('tolerance', 0.8)

	if(suit == 'ninja'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(0.1,0.1,0.1))
		_material.set_shader_parameter('tolerance', 1)

	if(suit == 'lava'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(1,0.1,0.1))
		_material.set_shader_parameter('tolerance', 0.9)

	if(suit == 'white'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(.8,.8,.8))
		_material.set_shader_parameter('tolerance', 0.9)

	if(suit == 'energy'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(0,1,1))
		_material.set_shader_parameter('tolerance', 2)

	if(suit == 'blue'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(.1,.1,.4))
		_material.set_shader_parameter('tolerance', 0.9)

	if(suit == 'pink'):
		_material.set_shader_parameter('targetColor', Vector3(0,1,0))
		_material.set_shader_parameter('replacementColor', Vector3(.9,.5,.9))
		_material.set_shader_parameter('tolerance', 0.9)

	if(suit == 'Url'):
		_material.set_shader_parameter('targetColor', Vector3(.4,.1,.1))
		_material.set_shader_parameter('replacementColor', Vector3(.75,.2,.45))
		_material.set_shader_parameter('tolerance', .3)

	if(suit == 'invisible'):
		modulate = Color(0,0,0,0)
		_material.set_shader_parameter('isReplacementColorDisabled', true)
		
		#_material.set_shader_parameter('replacementColor', Vector4(0,0,0, 0.1))
		#_material.set_shader_parameter('tolerance', 1)
