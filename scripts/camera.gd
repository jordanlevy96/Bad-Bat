extends Camera2D

# Variables to control the camera behavior
const AHEAD_DISTANCE: float = 50.0
const RESET_SPEED: float = 1.2
const VELOCITY_SMOOTHING: float = 0.5
const Y_OFFSET: float = -32.0

# Internal variables
var player
var velocity: Vector2 = Vector2.ZERO
var smoothed_velocity: Vector2 = Vector2.ZERO

func _ready():
	player = get_parent()
	global_position = player.global_position + Vector2(0, Y_OFFSET)
	print(global_position)

func _process(delta):
	if player:
		velocity = player.get_velocity()
		smoothed_velocity = smoothed_velocity.lerp(velocity, VELOCITY_SMOOTHING)
		update_camera_position(delta)
	else:
		print("Player not found")

func update_camera_position(delta):
	if smoothed_velocity.length() > 0:
		# Move camera ahead of the player when moving
		var camera_offset = smoothed_velocity.normalized() * AHEAD_DISTANCE
		camera_offset.y += Y_OFFSET
		global_position = global_position.lerp(player.global_position + camera_offset, delta * RESET_SPEED)
	else:
		# Reset camera to player position when stopped
		var target_position = player.global_position + Vector2(0, Y_OFFSET)
		global_position = global_position.lerp(target_position, delta * RESET_SPEED)

	print('updated')
	print(global_position)
