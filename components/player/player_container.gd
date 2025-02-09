extends Node2D

@export var show_hud = true

func _ready() -> void:
	$'hud'.visible = show_hud
