extends Node2D

func _ready():
	$player.position.x = get_node(
		'tiles/tile_success' + str(int(Global.lastLevelPlayed))).position.x
	$player.position.y = get_node(
		'tiles/tile_success' + str(int(Global.lastLevelPlayed))).position.y + 40
