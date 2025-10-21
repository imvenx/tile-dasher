extends Control

# Reference to the joystick visual components
@onready var base = $ColorRect  # The outer circle/base
#@onready var stick = $ColorRect2  # The inner stick (sibling to ColorRect)

# Joystick properties
var is_active = false
var touch_index = -1
var base_position = Vector2.ZERO
var stick_offset = Vector2.ZERO
var max_distance = 50.0  # Maximum drag distance from center

# Output vector for movement
var output_vector = Vector2.ZERO

func _ready():
	# Hide joystick initially
	#visible = false
	
	# Make sure the control can receive input
	mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event):
	# Handle touch/mouse press
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.position.x > get_viewport_rect().size.x / 2:
			return
		if event.pressed and not is_active:
			# Touch started - show and position joystick
			start_joystick(event.position)
			if event is InputEventScreenTouch:
				touch_index = event.index
		elif not event.pressed and is_active:
			# Touch ended - hide joystick
			if event is InputEventScreenTouch:
				if event.index == touch_index:
					stop_joystick()
			else:
				stop_joystick()
	
	# Handle touch/mouse drag
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if is_active:
			if event is InputEventScreenDrag:
				if event.index == touch_index:
					update_joystick(event.position)
			elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				update_joystick(event.position)

func start_joystick(pos: Vector2):
	$ColorRect/ColorRect.color = Color(0,1,1)
	
	is_active = true
	visible = true
	base_position = pos
	
	# Position the base at touch point
	#position = base_position - base.size / 2
	
	# Reset stick to center
	#stick.position = (base.size - stick.size) / 2
	output_vector = Vector2.ZERO

func update_joystick(pos: Vector2):
	# Calculate offset from base center
	var offset = pos - base_position
	
	# Clamp to max_distance
	if offset.length() > max_distance:
		offset = offset.normalized() * max_distance
	
	# Update stick visual position
	#var center_offset = (base.size - stick.size) / 2
	#stick.position = center_offset + offset
	
	# Calculate normalized output vector
	output_vector = offset / max_distance

func stop_joystick():
	$ColorRect/ColorRect.color = Color(0,0,0)
	
	is_active = false
	#visible = false
	output_vector = Vector2.ZERO
	touch_index = -1

func get_output_vector() -> Vector2:
	return output_vector
