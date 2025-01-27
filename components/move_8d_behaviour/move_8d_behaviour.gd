extends Node
class_name Move8DBehaviour

@export var initial_speed: float = 70.0  
@export var speed: float = initial_speed
@export var body: CharacterBody2D


func move_8d(_input_vector: Vector2, delta: float):
	# Normalize the input vector to avoid diagonal speed boost
	var input_vector = _input_vector.normalized()

	# Apply velocity and move
	body.velocity = input_vector * speed
	body.move_and_slide()


func modify_speed(new_speed):
	speed = new_speed
	
func reset_speed():
	speed = initial_speed
