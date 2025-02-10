extends Sprite2D
class_name DashBehaviour

@export var dashSpeed = 100
@export var dashCooldownTime = 1.0  # Full cooldown duration in seconds
@export var maxDashDistance = 100
@export var clampyDash: bool = true  # Enables clampy movement
@export var clampyIntervalFrames: int = 5  # How many frames before updating position
var initialDashJumpStep = 10
var initialDashEnergySpent = 20

signal dash(dashPosition: Vector2)

var isDashing = false
var dashTimer = 0.0
var energyPercent = 100
var clampyCounter = 0  # Frame counter for clampy movement

func _ready():
	visible = false

func _physics_process(delta: float) -> void:
	if isDashing:
		if position.x >= maxDashDistance or energyPercent <= 0:
			cancelDash()
		else:
			if clampyDash:
				clampyCounter += 1
				if clampyCounter >= clampyIntervalFrames:
					position.x += dashSpeed * (clampyIntervalFrames * delta)
					clampyCounter = 0  # Reset counter
			else:
				position.x += dashSpeed * delta  # Smooth movement
				
			updateDashProgress(delta) 
			updateOpacity()
	else:
		if dashTimer > 0:
			dashTimer -= delta
			updateCooldownProgress(delta)

func startDashing():
	if energyPercent <= 0: 
		return
		
	position.x += initialDashJumpStep
	energyPercent -= initialDashEnergySpent
	isDashing = true
	visible = true
	clampyCounter = 0
	$unload.play()

func stopDashing():
	if not isDashing: return
	visible = false
	dash.emit(global_position)
	isDashing = false
	adjustCooldownBasedOnDistance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)
	$unload.stop()
	$reload.play()
	
func cancelDash():
	visible = false
	isDashing = false
	adjustCooldownBasedOnDistance()
	position.x = 0
	modulate = Color(1, 1, 1, 1)
	$unload.stop()
	$reload.play()

func adjustCooldownBasedOnDistance():
	var distance_covered = position.x
	var proportion_used = distance_covered / maxDashDistance
	dashTimer = dashCooldownTime * proportion_used
	startCooldown()  # Update progress bar

func updateDashProgress(delta: float):
	var energy_spent = (dashSpeed * delta) / maxDashDistance * 100
	energyPercent = clamp(energyPercent - energy_spent, 0, 100)

func updateCooldownProgress(delta: float):
	if energyPercent < 100:
		var energy_recovered = delta / dashCooldownTime * 100
		energyPercent = clamp(energyPercent + energy_recovered, 0, 100)
	else:
		$reload.stop()

func updateOpacity():
	modulate = Color(0, 10, 100, energyPercent / 100)

func startCooldown():
	dashTimer = dashCooldownTime
		
func getProgress():
	return energyPercent
