extends CharacterBody2D

signal hit

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D


var is_crouching = false

var standing_cshape = preload("res://resources/player_standing_cshape.tres")
var crouching_cshape = preload("res://resources/player_crouching_cshape.tres")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration: -1, 0, 1
	var direction = Input.get_axis("left", "right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true
	
	# Crouch
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		stand()
	
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
	
	# Stealth mechanic
	if Input.is_action_just_pressed("crouch"):
		stealth()
	elif Input.is_action_just_released("crouch"):
		cancel_stealth()
	
	
func crouch():
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_cshape
	collision_shape.position.y = -12

func stand():
	if is_crouching == false:
		return
	is_crouching = false
	collision_shape.shape = standing_cshape
	collision_shape.position.y = -18
	
func stealth():
	set_collision_layer_value(2, false)
	print("ON")

func cancel_stealth():
	if get_collision_layer_value(2) == false:
		set_collision_layer_value(2, true)
		print("OFF")
