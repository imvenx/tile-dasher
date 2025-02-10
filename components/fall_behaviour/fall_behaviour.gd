extends Node
class_name FallBehaviour

@export var obj: Node2D
@export var fall_duration_seconds: float = 1.0  # Fall duration in seconds
var fall_timer: float = 0.0
var is_falling = false
signal ended_falling
var fall_sound: AudioStreamPlayer2D

func _ready():
	fall_sound = get_node_or_null('sound')

func _process(delta):
	if not is_falling: return
	
	fall_timer += delta
	var progress = fall_timer / fall_duration_seconds

	obj.scale = Vector2(1 - progress, 1 - progress)

	if fall_timer >= fall_duration_seconds:
		is_falling = false
		ended_falling.emit()


func start_falling():
	is_falling = true
	if fall_sound:
		fall_sound.play()
