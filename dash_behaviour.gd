extends Sprite2D
class_name DashBehaviour

@export var dash_speed = 1
signal dash(dash_position: Vector2)
var is_dashing = false

func _process(delta: float) -> void:

	if is_dashing:
		position.x += dash_speed


func start_dashing():
	is_dashing = true


func stop_dashing():
	dash.emit(global_position)
	is_dashing = false
	position.x = 0


func cancel_dash():
	is_dashing = false
	position.x = 0
