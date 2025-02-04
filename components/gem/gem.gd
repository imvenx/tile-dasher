extends Sprite2D

@onready var area2d = $Area2D

func _ready():
	area2d.connect('body_entered', on_body_entered)
	$AnimationPlayer.play("levitate")
	
	
func on_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):  # Replace with your player's name or group
		queue_free()
