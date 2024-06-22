extends Node2D

const SPEED = 90
const ATTACK_SPEED = 120
const SPRITE_OFFSET = 37
const KILLZONE_OFFSET = 13.5
const DETECTION_CONE_OFFSET = 16

enum SNAKE_STATE {
	PATROL,
	CHASE
}

var state = SNAKE_STATE.PATROL
var direction = -1
var attack_player = false

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_down = $RayCastDown
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sound = $AttackSound
@onready var detection_sprite = $AnimatedSprite2D/Sprite2D
@onready var player = %Player
@onready var killzone = $killzone
@onready var detection_cone = $DetectionCone

func _ready():
	ray_cast_right.add_exception(player)
	ray_cast_left.add_exception(player)
		
func _process(delta):
	if state == SNAKE_STATE.PATROL: 
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down.is_colliding():
			flip_snake()
			
	position.x += direction * SPEED * delta
	
	if attack_player:
		position.x += direction * ATTACK_SPEED * delta
			
func flip_snake():
	if direction == -1:
		direction = 1
		animated_sprite.flip_h = true
		detection_sprite.flip_h = true

		detection_sprite.position.x = SPRITE_OFFSET
		detection_cone.position.x = DETECTION_CONE_OFFSET
		killzone.position.x = KILLZONE_OFFSET

	elif direction == 1:
		direction = -1
		animated_sprite.flip_h = false
		detection_sprite.flip_h = false

		detection_sprite.position.x = -SPRITE_OFFSET
		detection_cone.position.x = -DETECTION_CONE_OFFSET
		killzone.position.x = -KILLZONE_OFFSET
	
	detection_cone.scale = -detection_cone.scale

func _on_killzone_body_entered(body):
	player = body
	attack_player = true
	animated_sprite.play("attack")
	attack_sound.play()
