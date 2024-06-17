extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("start"):
		_on_start_button_pressed()


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	$StartButton.show()	

	$Message.text = "Hide from the Enemies!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout


func _on_start_button_pressed():
	start_game.emit()
	$StartButton.hide()
	$Logo.hide()
	

func _on_message_timer_timeout():
	$ColorRect.hide()
	$Message.hide()
	queue_free()


