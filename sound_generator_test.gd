extends AudioStreamPlayer

func _ready():
	# Create the AudioStreamGenerator
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100  # Standard audio sample rate
	generator.buffer_length = 0.1  # Small buffer for real-time playback

	# Assign the generator to the player
	stream = generator

	# Instantiate the playback object
	var playback = generator.instantiate_playback()

	# Start playing
	play()

	# Generate a simple sound
	var frequency = 440.0  # A4 note frequency
	var samples = int(generator.mix_rate * generator.buffer_length)
	for i in range(samples):
		var t = float(i) / generator.mix_rate
		var wave = sin(2.0 * PI * frequency * t)  # Sine wave
		playback.push_frame(Vector2(wave, wave))  # Mono audio in both channels
