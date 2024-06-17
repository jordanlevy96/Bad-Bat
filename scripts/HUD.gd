extends CanvasLayer

func _ready():
	$Instructions.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$Logo.hide()
	$Instructions.show()
	$MessageTimer.start()

func _on_message_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
