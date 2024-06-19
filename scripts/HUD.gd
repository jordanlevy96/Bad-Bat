extends CanvasLayer

func _ready():
	$Instructions.hide()

func _process(_delta):
	if Input.is_action_just_pressed("start"):
		_on_start_button_pressed()

func _on_start_button_pressed():
	$StartButton.hide()
	$Logo.hide()
	$Instructions.show()
	$MessageTimer.start()

func _on_message_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
