extends Area2D

@export var warning_duration: float = 1.0  # Warning duration in seconds

#var is_falling: bool = false
var is_warning: bool = false
var warning_timer: float = 0.0

@onready var tile_sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var fall_behaviour: FallBehaviour = $fall_behaviour

func _ready() -> void:
	fall_behaviour.connect('ended_falling', on_ended_falling)

func _process(delta: float) -> void:
	if is_warning:
		warning_timer += delta
		# Tilt the tile slightly (oscillates back and forth)
		rotation = sin(warning_timer * 10) * 0.1

		tile_sprite.modulate = Color(1.0, 0.8, 0.8)  # Red color

		# Start falling after the warning duration
		if warning_timer >= warning_duration:
			is_warning = false
			warning_timer = 0.0
			collider.disabled = true
			#is_falling = true
			#$fall.is_falling = true
			fall_behaviour.start_falling()

	#elif is_falling:
	

func _on_body_entered(body: Node2D) -> void:
	if is_warning: return

	if body.is_in_group("player"):  # Replace with your player's name or group
		is_warning = true
		warning_timer = 0.0


func on_ended_falling():
	queue_free()
