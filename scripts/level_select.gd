extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("start"):
		_on_tutorial_button_pressed()

func _on_tutorial_button_pressed():
	$Instructions.show()
	$CenterContainer.hide()
	$MessageTimer.start()
	print('tutorial starting..')
	print($MessageTimer)

func _on_message_timer_timeout():
	print('timeout')
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")
