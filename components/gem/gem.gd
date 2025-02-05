extends Node2D

@onready var pick_sound = $SfxrStreamPlayer
@onready var anim_player = $AnimationPlayer

func _ready():
	connect('body_entered', on_body_entered)
	anim_player.play("levitate")
	
	
func on_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):  # Replace with your player's name or group
		pick_sound.play()
		visible = false
		pick_sound.connect("finished", queue_free)
		
		
		
