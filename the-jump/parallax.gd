extends ColorRect

@export var parallax_strength: float = 0.5  # Controls movement exaggeration
@export var depth_effect: float = 1.0  # Adjusts foreground-background visibility
@export var orbit_effect: float = 20.0  # How much the object "orbits" when moving left/right
@export var smoothing_speed: float = 10.0  # Adjust for smoother interpolation

var camera: Camera2D = null
var initial_position: Vector2
var rect_center: Vector2  # The real center of this ColorRect
var target_position: Vector2  # Used for smoothing

func _ready():
	camera = get_viewport().get_camera_2d()
	initial_position = position
	rect_center = global_position + (size / 2)  # Correctly find the center of the rect
	target_position = position  # Initialize target position

func _process(delta):  # Process for smooth frame updates
	if camera:
		var cam_pos = camera.global_position

		# **Calculate the camera's position relative to this object's center**
		var relative_camera_position = cam_pos - rect_center  # NO delta here!

		# **Apply Parallax Effect**
		var offset = relative_camera_position * (parallax_strength / 5)
		var new_position = initial_position + offset

		# **X-axis shift effect (Perspective orbit)**
		var orbit_shift = clamp(relative_camera_position.x / 150.0, -1.0, 1.0) * orbit_effect
		new_position.x -= orbit_shift  # Corrected direction

		# **Y-axis depth effect (Foreground vs Background reveal)**
		var depth_factor = clamp(relative_camera_position.y / 300.0, -1.0, 1.0) * depth_effect
		new_position.y += depth_factor * 10  

		# **Apply Smooth Interpolation (Delta-Based)**
		target_position = new_position
		position = position.lerp(target_position, 1.0 - exp(-delta * smoothing_speed))  # Best smoothing function

		# **Optional: Adjust transparency to simulate depth**
		# modulate.a = 1.0 - abs(depth_factor) * 0.3
