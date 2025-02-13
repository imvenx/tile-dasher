extends Node

var SDK
var game
var _adCallbacks

func _ready() -> void:
	if not OS.has_feature("crazygames"): return

	var window = JavaScriptBridge.get_interface("window")
	SDK = window.CrazyGames.SDK
	game = SDK.game
	
	var adStartedCallback = JavaScriptBridge.create_callback(_adStarted)
	var adErrorCallback = JavaScriptBridge.create_callback(_adError)
	var adFinishedCallback = JavaScriptBridge.create_callback(_adFinished)
	
	_adCallbacks = JavaScriptBridge.create_object("Object")
	_adCallbacks["adFinished"] = adFinishedCallback
	_adCallbacks["adError"] = adErrorCallback
	_adCallbacks["adStarted"] = adStartedCallback
	
	

func gameplayStart():
	if _isSdkDisabled(): return
	game.gameplayStart()
	
func happytime():
	if _isSdkDisabled(): return
	game.happytime()
	
func gameplayStop():
	if _isSdkDisabled(): return
	game.gameplayStop()


@warning_ignore("unused_signal")
signal ad_started
@warning_ignore("unused_signal")
signal ad_finished
@warning_ignore("unused_signal")
signal ad_error

func _adStarted(args):
	emit_signal("ad_started")

func _adError(error):
	emit_signal("ad_error", error)

func _adFinished(args):
	emit_signal("ad_done")
	
func requestRewardedAd():
	if _isSdkDisabled(): return
	SDK.ad.requestAd("rewarded", _adCallbacks)

func _isSdkDisabled():
	return not OS.has_feature("crazygames")
	
