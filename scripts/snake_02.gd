extends Node2D

const SPEED = 60
const attack_SPEED = 120

var direction = -1
var attack_player = false

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_sound = $AttackSound
@onready var detection_sprite = $AnimatedSprite2D/Sprite2D
@onready var player = %Player
@onready var killzone = $killzone


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
		detection_sprite.flip_h = false
		detection_sprite.position.x = -30
		killzone.position.x = -11
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
		detection_sprite.flip_h = true
		detection_sprite.position.x = 30
		killzone.position.x = 11
		
	position.x += direction * SPEED * delta
	
	ray_cast_right.add_exception(player)
	ray_cast_left.add_exception(player)
	
	if attack_player:
		position.x += direction * attack_SPEED * delta
	

func _on_killzone_body_entered(body):
	player = body
	attack_player = true
	animated_sprite.play("attack")
	attack_sound.play()
	


