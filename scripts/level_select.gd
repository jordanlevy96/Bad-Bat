extends CanvasLayer

func _on_tutorial_button_pressed():
	$Instructions.show()
	$CenterContainer.hide()
	$MessageTimer.start()
	print('tutorial starting..')
	print($MessageTimer)

func _on_message_timer_timeout():
	print('timeout')
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")
