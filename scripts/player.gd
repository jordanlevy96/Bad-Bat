extends CharacterBody2D

signal hit

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const CROUCH_OFFSET = 9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var raycast_crouching_1 = $RayCast2D_Crouching1
@onready var raycast_crouching_2 = $RayCast2D_Crouching2

var jump_press = 0.0
var jump_timer = 0.0
var jump_time = 0.1 #how long the player can still jump after starting to fall

var is_crouching = false
var stuck_crouching = false
var is_hidden = false

var standing_cshape = preload("res://resources/player_standing_cshape.tres")
var crouching_cshape = preload("res://resources/player_crouching_cshape.tres")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		jump_timer = 0.0
	else:
		jump_timer += delta
		jump_press -= delta
	
	if jump_press < 0.0:
		jump_press = 0.0
	
	if Input.is_action_just_pressed("jump") and jump_timer < jump_time:
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump"):
		jump_press = 0.1
				
	if is_on_floor() and (jump_press > 0.0):
		print(jump_press)
		velocity.y = JUMP_VELOCITY
		jump_press = 0.0
	
	# Get the input direction and handle the movement/deceleration: -1, 0, 1
	var direction = Input.get_axis("left", "right")
	
	# Flip the Sprite
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
		animated_sprite.position.x = direction * -5
	
	# Crouch
	if Input.is_action_just_pressed("crouch"):
		crouch()
		# Stealth mechanic (if colliding with rock and crouching)
		if is_hidden:
			stealth()
		else:
			cancel_stealth()
	elif Input.is_action_just_released("crouch"):
		if not_stuck_crouching():
			stand()
			cancel_stealth()
		else:
			if stuck_crouching !=true:
				stuck_crouching = true
	
	if is_crouching:
		if is_hidden:
			stealth()

	
	if stuck_crouching and not_stuck_crouching():
		stand()
		cancel_stealth()
		stuck_crouching = false
	
	#Play animations
	if is_on_floor():
		if direction == 0:
			if is_crouching:
				animated_sprite.play("crouch_idle")
			else: 
				animated_sprite.play("idle")
		else:
			if is_crouching:
				animated_sprite.play("crouch_run")
			else: 
				animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else: 
			animated_sprite.play("fall")
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func not_stuck_crouching() -> bool:
	var result = not raycast_crouching_1.is_colliding() and not raycast_crouching_2.is_colliding()
	return result
	
func crouch():
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_cshape
	collision_shape.position.y += CROUCH_OFFSET

func stand():
	if is_crouching == false:
		return
	is_crouching = false
	collision_shape.shape = standing_cshape
	collision_shape.position.y -= CROUCH_OFFSET
	cancel_stealth()
	
func stealth():
	set_collision_layer_value(2, false)
	print("Invisible")

func cancel_stealth():
	if get_collision_layer_value(2) == false:
		set_collision_layer_value(2, true)
		print("Visible")
