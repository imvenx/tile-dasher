extends Node
class_name RotateBehaviour

@export var initial_rotation_speed: float = 10.0  
var rotation_speed: float = initial_rotation_speed  
@export var body: CharacterBody2D


func rotate(_input_vector: Vector2, delta: float):
	var input_vector = _input_vector.normalized()

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
