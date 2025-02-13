extends Area2D

@export var is_goal = true
@export var go_to_level_number: int
var is_disabled = false
@export var text = ''
#var numbers = ['I', 'V', 'A', 'Z', 'H']

func _ready() -> void:
	$RichTextLabel.text = text
	
	if not is_goal and go_to_level_number != 0:
		
		is_disabled = Global.lastUnlockedLevel < go_to_level_number
			
		if is_disabled:
			$PointLight2D.visible = false
			modulate = Color(.5,.5,.5,1)
			$RichTextLabel.modulate = Color(1,1,1,.05)
	
		#else: $RichTextLabel.text = numbers[go_to_level_number - 1]
			
		$gems.visible = true
		if go_to_level_number < Global.collectedGems.size():
			var gems = Global.collectedGems[go_to_level_number - 1]
			for gem in gems:
				get_node('gems/' + gem).modulate = Color(1,1,1,1)
				
		
var player
func _on_body_entered(body: Node2D) -> void:
	
	if is_disabled: return
	
	if(body.is_in_group('player')):
		disconnect("body_entered", _on_body_entered)
		player = body
	
		if go_to_level_number != 0:
			Global.setLastLevelPlayed(go_to_level_number)
			playActivateAnim()
			await get_tree().create_timer(1).timeout
			Global.go_to_level.emit(go_to_level_number)
			return
		
		if not is_goal: 	return
		
		elif body.is_in_group("player"): 
			playActivateAnim()
			await get_tree().create_timer(1).timeout
			Global.level_completed.emit()
			

func playActivateAnim():
	var sprite := $Sprite2D2
	sprite.frame = 0  # Start at frame 0
	$SuccessPlatformActivate.play()
	var light:PointLight2D = $PointLight2D
	
	for i in range(7):  # Frames 0 to 7
		sprite.frame = i
		await get_tree().create_timer(0.1).timeout  # Adjust time per frame
		light.energy *= 1.1
		light.scale *= 1.015
		light.texture_scale += 0.01
		$RichTextLabel.modulate *= 1.4
		

	for j in range(30):
		position.y -= 1
		player.position.y -= 1
		if(go_to_level_number != 0):
			scale /= 1.003
			player.scale /= 1.003
		else:
			scale *= 1.003
			player.scale *= 1.003
		
		#player.position.y = 1
		await get_tree().create_timer(0.03).timeout  # Adjust time per frame
