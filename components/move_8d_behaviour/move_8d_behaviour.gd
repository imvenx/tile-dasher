extends Node
class_name Move8DBehaviour

@export var initial_speed: float = 70.0  
@export var speed: float = initial_speed
@export var acceleration: float = 400.0  # Acceleration speed
@export var deceleration: float = 400.0  # Deceleration speed
@export var body: CharacterBody2D

var is_walking = false
signal started_moving
signal stoped_moving

var input_vector = Vector2.ZERO
var current_velocity = Vector2.ZERO  # Track movement velocity

func move_8d(_input_vector: Vector2):
	input_vector = _input_vector.normalized()  # Normalize input once

func _physics_process(delta: float):
	if input_vector == Vector2.ZERO:
		# Decelerate when no input is given
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration * delta)
		if is_walking and current_velocity.length() < 1.0:
			is_walking = false
			stoped_moving.emit()
	else:
		if not is_walking:
			is_walking = true
			started_moving.emit()
		
		# Accelerate towards target speed
		var target_velocity = input_vector * speed
		current_velocity = current_velocity.move_toward(target_velocity, acceleration * delta)

	# Apply movement
	body.velocity = current_velocity
	body.move_and_slide()

func change_speed(new_speed: float):
	speed *= new_speed
	
func reset_speed():
	speed = initial_speed


func stop_moving():
	input_vector = Vector2.ZERO
	
