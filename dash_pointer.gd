extends Sprite2D

signal dash(dash_position: Vector2)
var is_dashing = false


func _process(delta: float) -> void:

	#if Input.is_key_pressed(KEY_K):
		#is_dashing = true
	if is_dashing:
		position.x += 2
		
	#elif is_dashing: 
		#dash.emit(global_position)
		#is_dashing = false
		#position.x = 0


func start_dashing():
	is_dashing = true


func stop_dashing():
	is_dashing = false
	position.x = 0
