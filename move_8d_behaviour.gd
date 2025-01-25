extends Node
class_name Move8DBehaviour

@export var speed: float = 100.0
@export var initial_rotation_speed: float = 15.0  
var rotation_speed: float = initial_rotation_speed  
@export var body: CharacterBody2D
var input_vector = Vector2.ZERO


func move_8d(_input_vector: Vector2, delta: float):
	input_vector = _input_vector
	# Normalize the input vector to avoid diagonal speed boost
	input_vector = input_vector.normalized()

	# Apply velocity and move
	body.velocity = input_vector * speed
	body.move_and_slide()

	# Rotate the player smoothly towards the direction of movement
	if input_vector != Vector2.ZERO:
		var target_rotation = input_vector.angle()
		body.rotation = lerp_angle(
			body.rotation,
			target_rotation, 
			rotation_speed * delta)

func modify_rotation_speed(new_speed):
	rotation_speed = new_speed
	
func reset_rotation_speed():
	rotation_speed = initial_rotation_speed
