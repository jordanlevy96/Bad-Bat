extends Area2D

@onready var player = %Player

func _on_body_entered(_body):
	player.is_hidden = true


func _on_body_exited(_body):
	player.is_hidden = false

