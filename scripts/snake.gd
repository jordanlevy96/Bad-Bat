extends Node2D

const SPEED = 90
const ATTACK_SPEED = 120
const SPRITE_OFFSET = 37
const DOWN_RAY_OFFSET = 16
const KILLZONE_OFFSET = 13.5
const DETECTION_CONE_OFFSET = 16
const DETECTION_LABEL_OFFSET = Vector2(-25, -50)
const ATTACK_ZONE_OFFSET = 27
const FRONT_RAY_TARGET = 35
const BACK_RAY_TARGET = 16
const SNAKE_LAZINESS_SCORE = 5 # time in s before snake gives up looking for player

enum SNAKE_STATE {
	PATROL,
	ATTACK,
	EAT
}

var label: Label
var state = SNAKE_STATE.PATROL
var direction = -1
var time_since_player_seen = 0
var sees_player = false
var attacking = false

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_down = $RayCastDown
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sound = $AttackSound
@onready var detection_sprite = $AnimatedSprite2D/Sprite2D
@onready var player = %Player
@onready var killzone = $killzone
@onready var detection_cone = $DetectionCone
@onready var attack_zone = $AttackZone

func _ready():
	ray_cast_right.add_exception(player)
	ray_cast_left.add_exception(player)
		
func _process(delta):
	if not animated_sprite.is_playing():
		animated_sprite.play("walk")
		
	if not sees_player:
		time_since_player_seen += delta
	
	if state == SNAKE_STATE.PATROL: 
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or not ray_cast_down.is_colliding():
			flip_snake()
			
		position.x += direction * SPEED * delta
		
	elif state == SNAKE_STATE.ATTACK:
		#TODO: deeper look into attack strategy
		#	- should the snake go up ramps to follow the player?
		#	- what happens if the snake watches you hide?
		if ray_cast_down.is_colliding() and not ray_cast_left.is_colliding() and not ray_cast_right.is_colliding():
			position.x += direction * ATTACK_SPEED * delta
		
		if time_since_player_seen >= SNAKE_LAZINESS_SCORE:
			state = SNAKE_STATE.PATROL
			label.queue_free()
			
func flip_snake():
	if direction == -1:
		direction = 1
		animated_sprite.flip_h = true
		detection_sprite.flip_h = true

		detection_sprite.position.x = SPRITE_OFFSET
		detection_cone.position.x = DETECTION_CONE_OFFSET
		killzone.position.x = KILLZONE_OFFSET
		attack_zone.position.x = ATTACK_ZONE_OFFSET
		
		ray_cast_down.position.x = DOWN_RAY_OFFSET
		ray_cast_left.target_position.x = -BACK_RAY_TARGET
		ray_cast_right.target_position.x = FRONT_RAY_TARGET

	elif direction == 1:
		direction = -1
		animated_sprite.flip_h = false
		detection_sprite.flip_h = false

		detection_sprite.position.x = -SPRITE_OFFSET
		detection_cone.position.x = -DETECTION_CONE_OFFSET
		killzone.position.x = -KILLZONE_OFFSET
		attack_zone.position.x = -ATTACK_ZONE_OFFSET
		
		ray_cast_down.position.x = -DOWN_RAY_OFFSET
		ray_cast_left.target_position.x = -FRONT_RAY_TARGET
		ray_cast_right.target_position.x = BACK_RAY_TARGET
	
	detection_cone.scale = -detection_cone.scale

func _on_detection_cone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	sees_player = true
	time_since_player_seen = 0
	
	if state == SNAKE_STATE.PATROL:
		label = Label.new()
		label.text = "!"
		label.set_anchors_preset(Control.PRESET_CENTER_TOP, true)
		add_child(label)
		label.position += DETECTION_LABEL_OFFSET
		state = SNAKE_STATE.ATTACK

func _on_detection_cone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	sees_player = false

func _on_attack_zone_body_entered(body):
	attack_sound.play()
	animated_sprite.play("attack")
	attacking = true


func _on_animated_sprite_2d_animation_looped():
	if attacking:
		attacking = false
		animated_sprite.stop()
