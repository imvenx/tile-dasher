extends Node

var SDK = null

func _ready() -> void:
	if not OS.has_feature("crazygames"): return

	var window = JavaScriptBridge.eval("window")
	SDK = window.CrazyGames.SDK
