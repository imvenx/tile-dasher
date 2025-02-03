extends Node
class_name FloorDetector

@export var area2d: Area2D
@export var fall_delay: float = 0.01  # Delay in seconds before detecting fall
var touching_floor_points = 0
var has_fallen = false
signal fallen

var fall_timer: Timer

func _ready():
	# Connect signals for the area
	area2d.connect('area_entered', _on_area_2d_area_entered)
	area2d.connect('area_exited', _on_area_2d_area_exited)
	
	# Initialize the timer
	fall_timer = Timer.new()
	fall_timer.wait_time = fall_delay
	fall_timer.one_shot = true
	fall_timer.connect('timeout', _on_fall_timer_timeout)
	add_child(fall_timer)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('floor'):
		touching_floor_points += 1
		# Cancel the timer if it was running
		if fall_timer.is_stopped() == false:
			fall_timer.stop()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group('floor'):
		touching_floor_points -= 1
		if touching_floor_points <= 0:
			# Start the timer when exiting the floor
			fall_timer.start()

func _on_fall_timer_timeout() -> void:
	# If still not touching the floor after the delay, emit the signal
	if touching_floor_points <= 0:
		fall_timer.disconnect('timeout', _on_fall_timer_timeout)
		has_fallen = true
		fallen.emit()
