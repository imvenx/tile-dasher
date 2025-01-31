extends Node
class_name Move8DBehaviour

@export var initial_speed: float = 70.0  
@export var speed: float = initial_speed
@export var body: CharacterBody2D
var is_walking = false
signal started_moving
signal stoped_moving

func move_8d(_input_vector: Vector2, delta: float):
	# Normalize the input vector to avoid diagonal speed boost
	var input_vector = _input_vector.normalized()
	if input_vector == Vector2.ZERO:
		if is_walking:
			is_walking = false
			stoped_moving.emit()
		return
		
	if not is_walking:
		is_walking = true
		started_moving.emit()
	
	# Apply velocity and move
	body.velocity = input_vector * speed
	body.move_and_slide()


func modify_speed(new_speed):
	speed = new_speed
	
func reset_speed():
	speed = initial_speed
