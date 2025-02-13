extends Area2D

var waypointPositions: Array[Vector2] = []
var currentIndex: int = 0
var direction: int = 1
var player: Node2D = null
var previousPosition: Vector2
var sprite: Sprite2D = null

var speed: int
var reverse: bool
var loop: bool
var initialDelay: float
var startOnPlayerEnter: bool
var isDisabled: bool

var delayTimer: float = 0.0
var isDelaying: bool = true
var waitingForPlayer: bool = false

func _ready():
	speed = $tile_move_config.get_meta("speed")
	reverse = $tile_move_config.get_meta("reverse")
	loop = $tile_move_config.get_meta("loop")
	initialDelay = $tile_move_config.get_meta("initialDelay", 0.0)
	startOnPlayerEnter = $tile_move_config.get_meta("startOnPlayerEnter", false)
	isDisabled = $tile_move_config.get_meta("isDisabled", false)

	connect('body_entered', _onBodyEntered)
	connect('body_exited', _onBodyExited)

	sprite = $Sprite2D

	waypointPositions.append(global_position)

	var waypoints = $waypoints
	if waypoints != null:
		for waypoint in waypoints.get_children():
			if waypoint is Node2D:
				waypointPositions.append(waypoint.global_position)

	previousPosition = global_position
	delayTimer = initialDelay  # Start delay countdown

	# If tile is disabled, dim it and completely prevent movement
	if isDisabled:
		modulate = Color(0.5, 0.5, 0.5, 1)
		isDelaying = true
		waitingForPlayer = false  # Ensure it never starts moving
		speed = 0  # Hard stop movement by setting speed to 0

	# If startOnPlayerEnter is enabled, wait for the player to step in
	elif startOnPlayerEnter:
		isDelaying = true
		waitingForPlayer = true

func _process(delta):
	if isDisabled:
		return  # Completely prevent movement if disabled

	if isDelaying:
		delayTimer -= delta
		if delayTimer <= 0 and not waitingForPlayer:
			isDelaying = false
		return  # Stop processing movement while delaying

	if waypointPositions.is_empty():
		return

	var targetPosition = waypointPositions[currentIndex]
	var directionVector = (targetPosition - global_position).normalized()

	if directionVector.length() > 0.01:
		_updateSpriteByDirection(directionVector)
	else:
		_updateSprite(0)

	previousPosition = global_position
	global_position += directionVector * speed * delta

	if player:
		var movementOffset = global_position - previousPosition
		player.global_position += movementOffset

	if global_position.distance_to(targetPosition) < speed * delta:
		_advanceIndex()

func _advanceIndex():
	currentIndex += direction

	if waypointPositions.size() == 1:
		currentIndex = 0
		return

	if currentIndex >= waypointPositions.size():
		if loop:
			currentIndex = 0
		elif reverse:
			direction = -1
			currentIndex = waypointPositions.size() - 2
		else:
			currentIndex = waypointPositions.size() - 1

	elif currentIndex < 0:
		direction = 1
		currentIndex = 1

func _updateSpriteByDirection(directionVector: Vector2):
	if abs(directionVector.x) > abs(directionVector.y):
		if directionVector.x > 0:
			_updateSprite(2)
		else:
			_updateSprite(4)
	else:
		if directionVector.y > 0:
			_updateSprite(3)
		else:
			_updateSprite(1)

func _updateSprite(frame: int):
	if sprite and sprite.frame != frame:
		sprite.frame = frame

func _onBodyEntered(body: Node2D):
	if body.is_in_group("player"):
		player = body
		if waitingForPlayer:
			isDelaying = false  # Start movement
			waitingForPlayer = false  # Stop waiting for player

func _onBodyExited(body: Node2D):
	if body == player:
		player = null

func setDisabled(val: bool):
	isDisabled = val  # Set the new value

	if isDisabled:
		modulate = Color(0.5, 0.5, 0.5, 1)
		isDelaying = true  # Prevent movement
		speed = 0  # Stop all movement
	else:
		modulate = Color(1, 1, 1, 1)
		isDelaying = false  # Allow movement again
		speed = $tile_move_config.get_meta("speed")  # Restore original speed

		# If it needs to wait for player input, restore that behavior
		if startOnPlayerEnter:
			isDelaying = true
			waitingForPlayer = true

		# If there was an initial delay, reapply it
		elif initialDelay > 0:
			isDelaying = true
			delayTimer = initialDelay
