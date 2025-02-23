extends Node2D

var isPlayerInside = false

func _ready() -> void:
	$tooltip.modulate.a = 0
	$Area2D.connect('body_entered', onBodyEnter)
	$Area2D.connect('body_exited', onBodyExit)
	$RichTextLabel.text = name.capitalize()

func onBodyEnter(body: Node2D) -> void:
	if body.is_in_group("player"): 
		isPlayerInside = true
		$"SfxrStreamPlayer".play()
		
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($tooltip, "modulate:a", 1.0, 0.3) 
		#if not Global.unlockedSuits.has(name):
			#await get_tree().create_timer(.5).timeout

func onBodyExit(body: Node2D) -> void:
	if body.is_in_group("player"): 
		isPlayerInside = false
		
		if Global.unlockedSuits.has(name):
			pass
			#Global.setCurrentSuit(name)
		else:
			var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($tooltip, "modulate:a", 0.0, 0.3)
			body.changeSuit(Global.currentSuit)

func _input(event: InputEvent) -> void:
	if isPlayerInside and event.is_action_pressed("ui_accept"):
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($tooltip, "modulate:a", 0.0, 0.3)
		
		var links = {
			Discord = 'https://discord.gg/egJCEWRhpz',
			Mastodon = 'https://mastodon.social/@nexype',
		}
		Global.open_link(links[name])
		#Global.addUnlockedSuit(name)
		#CrazySdk.requestRewardedAd()
