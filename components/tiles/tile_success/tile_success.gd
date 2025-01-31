extends Area2D

@export var is_goal = true

func _on_body_entered(body: Node2D) -> void:
	
	if not is_goal: return
	
	if body.is_in_group("player"): 
		GlobalEvents.level_completed.emit()
