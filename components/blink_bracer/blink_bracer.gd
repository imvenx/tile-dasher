extends Area2D

func _ready() -> void:
	connect('body_entered', _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"): 
		print('player took blink bracer')
		queue_free()
