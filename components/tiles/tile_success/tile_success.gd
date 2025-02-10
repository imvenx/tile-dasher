extends Area2D

@export var is_goal = true
@export var go_to_level_number: int
var is_disabled = false
@export var text = ''
#var numbers = ['I', 'V', 'A', 'Z', 'H']

func _ready() -> void:
	$RichTextLabel.text = text
	
	if not is_goal and go_to_level_number != 0:
		
		
		is_disabled = Global.last_unlocked_level < go_to_level_number
			
		if is_disabled:
			modulate = Color(.5,.5,.5,1)
			$RichTextLabel.modulate = Color(1,1,1,.05)
	
		#else: $RichTextLabel.text = numbers[go_to_level_number - 1]
			
		$gems.visible = true
		if go_to_level_number < Global.collected_gems.size():
			var gems = Global.collected_gems[go_to_level_number - 1]
			for gem in gems:
				get_node('gems/' + gem).modulate = Color(1,1,1,1)
				
		

func _on_body_entered(body: Node2D) -> void:
	
	if is_disabled: return
	
	if go_to_level_number != 0:
		Global.go_to_level.emit(go_to_level_number)
		return
	
	if not is_goal: return
	
	elif body.is_in_group("player"): 
		Global.level_completed.emit()
