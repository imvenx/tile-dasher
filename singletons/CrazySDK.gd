extends Node

var SDK = null
var game = null

func _ready() -> void:
	if not OS.has_feature("crazygames"): return

	var window = JavaScriptBridge.get_interface("window")
	SDK = window.CrazyGames.SDK
	game = SDK.game
	
	var adStartedCallback = JavaScriptBridge.create_callback(adStarted)
	var adErrorCallback = JavaScriptBridge.create_callback(adError)
	var adFinishedCallback = JavaScriptBridge.create_callback(adFinished)
	

func gameplayStart():
	if not OS.has_feature("crazygames"): return
	game.gameplayStart()
	
func happytime():
	if not OS.has_feature("crazygames"): return
	game.happytime()
	
func gameplayStop():
	if not OS.has_feature("crazygames"): return
	game.gameplayStop()


signal ad_started
signal ad_finished
signal ad_error

func adStarted(args):
	emit_signal("ad_started")

func adError(error):
	emit_signal("ad_error", error)

func adFinished(args):
	emit_signal("ad_done")
