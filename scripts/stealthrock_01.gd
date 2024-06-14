extends Area2D

@onready var player = %Player

func _on_body_entered(_body):
	print("Invisible")


func _on_body_exited(_body):
	print("Visible")

