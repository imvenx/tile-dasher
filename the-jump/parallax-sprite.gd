extends Node2D  # Base for parallax objects

@export var parallax_strength: float = 0.5  # Controls movement exaggeration
@export var depth_effect: float = 1.0  # Adjusts foreground-background visibility
@export var orbit_effect_x: float = 10.0  # X-axis orbit strength (lowered)
@export var orbit_effect_y: float = 20.0  # Y-axis orbit strength (higher)
@export var pixel_size: float = 0.5  # Supports fractional pixel sizes (e.g., 0.5, 1.0, 2.0)
@export var use_pixel_snapping: bool = true  # Toggle between pixel-perfect & smooth movement

var camera: Camera2D = null
var initial_position: Vector2
var node_center: Vector2  # The real center of this Node2D
var target_position: Vector2  # Used for positioning

func _ready():
	camera = get_viewport().get_camera_2d()
	initial_position = position
	node_center = global_position  # Get Node2D's center
	target_position = position  # Initialize target position

func _process(_delta):  
	if camera:
		var cam_pos = camera.global_position

		# **Calculate the camera's position relative to this object's center**
		var relative_camera_position = cam_pos - node_center  

		# **Fix: Scale movement using a smoother function (cubic scale)**
		var scaled_parallax = pow(parallax_strength, 1.5)  # Ensures smoother scaling
		var offset = relative_camera_position * (scaled_parallax / 5) * Vector2(-1, -1)
		var new_position = initial_position + offset

		# **If parallax strength is 0, stay at initial position**
		if parallax_strength == 0:
			position = initial_position
			return  # Exit early to prevent unnecessary calculations

		# **Balanced X & Y Orbit Shift**
		var orbit_shift_x = clamp(relative_camera_position.x / 150.0, -1.0, 1.0) * orbit_effect_x * scaled_parallax
		var orbit_shift_y = clamp(relative_camera_position.y / 300.0, -1.0, 1.0) * orbit_effect_y * scaled_parallax
		new_position.x -= orbit_shift_x  
		new_position.y += orbit_shift_y  

		# **Toggle Pixel-Perfect Snapping**
		if use_pixel_snapping:
			new_position.x = round(new_position.x / pixel_size) * pixel_size
			new_position.y = round(new_position.y / pixel_size) * pixel_size

		position = new_position  # Apply final position
