extends Sprite2D
class_name DashBehaviour

@export var dash_speed = 100
@export var dash_cooldown_time = 1.0  # Full cooldown duration in seconds
@export var max_dash_distance = 80
@export var progress_bar: TextureProgressBar  # Reference to the progress bar

signal dash(dash_position: Vector2)

var is_dashing = false
var dash_timer = 0.0
var energy_percent = 100

func _ready() -> void:
	# Ensure the progress bar starts hidden and at max value
	if progress_bar:
		progress_bar.visible = false
		progress_bar.value = 100

func _process(delta: float) -> void:
	# Update dash progress bar while dashing
	if is_dashing:
		if position.x >= max_dash_distance or energy_percent <= 0:
			cancel_dash()
		else:
			position.x += dash_speed * delta
			update_dash_progress(delta)  # Decrease progress bar during dash
			update_opacity()        # Adjust opacity based on distance
	else:
		# Update dash timer and progress bar during cooldown
		if dash_timer > 0:
			dash_timer -= delta
			update_cooldown_progress(delta)
		elif progress_bar and progress_bar.visible:
			progress_bar.visible = false  # Hide progress bar when cooldown finishes

func start_dashing():
	if energy_percent <= 0:  # Prevent dashing if no energy is available
		return
	is_dashing = true
	progress_bar.visible = true

func stop_dashing():
	if not is_dashing: return
	dash.emit(global_position)
	is_dashing = false
	adjust_cooldown_based_on_distance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)  # Reset opacity

func cancel_dash():
	is_dashing = false
	adjust_cooldown_based_on_distance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)  # Reset opacity

func adjust_cooldown_based_on_distance():
	# Proportional cooldown based on how much dash distance was covered
	var distance_covered = position.x
	var proportion_used = distance_covered / max_dash_distance
	dash_timer = dash_cooldown_time * proportion_used
	start_cooldown()  # Update progress bar

func update_dash_progress(delta: float):
	if progress_bar:
		# Reduce energy proportionally to the movement during this frame
		var energy_spent = (dash_speed * delta) / max_dash_distance * 100
		energy_percent = clamp(energy_percent - energy_spent, 0, 100)
		progress_bar.value = energy_percent


func update_cooldown_progress(delta: float):
	if progress_bar:
		# Gradually recover energy based on cooldown time
		if energy_percent < 100:
			var energy_recovered = delta / dash_cooldown_time * 100
			energy_percent = clamp(energy_percent + energy_recovered, 0, 100)
			progress_bar.value = energy_percent


func update_opacity():
	# Calculate the remaining distance proportion
	#var remaining_distance = max_dash_distance - position.x
	#var alpha = clamp(remaining_distance / max_dash_distance, 0, 1)
	modulate = Color(1, 1, 1, energy_percent / 100)  # Set opacity based on alpha

func start_cooldown():
	dash_timer = dash_cooldown_time  # Reset the timer for recovery
	if progress_bar:
		progress_bar.visible = true
