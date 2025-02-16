extends GPUParticles2D

func _ready():
	# Wait a random time between 1 and 5 seconds before starting
	#_change_color()
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	
	# Create and configure the timer
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)

	# Play the sound immediately on start
	_on_timer_timeout()

func _on_timer_timeout():
	$"explosion-sound".play()
	set_emitting(true)

#func _change_color():
	## Define a list of vibrant colors
	#var colors = [
		##Color(1.0, 0.0, 0.0),  # Red
		#Color(1.0, 0.4, 0.8),  # Pink
		#Color(1.0, 1.0, 0.0),  # Yellow
		#Color(0.0, 1.0, 1.0),  # Cyan
		#Color(1.0, 0.5, 0.0),  # Orange
		##Color(0.5, 0.0, 1.0),  # Purple
	#]
#
	## Pick a random color
	#modulate = colors[randi() % colors.size()]
