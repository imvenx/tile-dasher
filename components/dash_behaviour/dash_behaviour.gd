extends Sprite2D
class_name DashBehaviour

@export var dash_speed = 100
@export var dash_cooldown_time = 1.0  # Full cooldown duration in seconds
@export var max_dash_distance = 80

signal dash(dash_position: Vector2)

var is_dashing = false
var dash_timer = 0.0
var energy_percent = 100

func _ready():
	visible = false

func _physics_process(delta: float) -> void:
	if is_dashing:
		if position.x >= max_dash_distance or energy_percent <= 0:
			cancel_dash()
		else:
			position.x += dash_speed * delta
			update_dash_progress(delta) 
			update_opacity()
	else:
		if dash_timer > 0:
			dash_timer -= delta
			update_cooldown_progress(delta)

func start_dashing():
	if energy_percent <= 0: 
		return
		
	energy_percent -= 15
	is_dashing = true
	visible = true
	$unload.play()


func stop_dashing():
	if not is_dashing: return
	visible = false
	dash.emit(global_position)
	is_dashing = false
	adjust_cooldown_based_on_distance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)
	$unload.stop()
	$reload.play()
	

func cancel_dash():
	visible = false
	is_dashing = false
	adjust_cooldown_based_on_distance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)
	$unload.stop()
	$reload.play()

func adjust_cooldown_based_on_distance():
	var distance_covered = position.x
	var proportion_used = distance_covered / max_dash_distance
	dash_timer = dash_cooldown_time * proportion_used
	start_cooldown()  # Update progress bar

func update_dash_progress(delta: float):
	var energy_spent = (dash_speed * delta) / max_dash_distance * 100
	energy_percent = clamp(energy_percent - energy_spent, 0, 100)

func update_cooldown_progress(delta: float):
	if energy_percent < 100:
		var energy_recovered = delta / dash_cooldown_time * 100
		energy_percent = clamp(energy_percent + energy_recovered, 0, 100)
	else:
		$reload.stop()
		

func update_opacity():
	modulate = Color(0, 10, 100, energy_percent / 100)

func start_cooldown():
	dash_timer = dash_cooldown_time
		
func get_progress():
	return energy_percent
