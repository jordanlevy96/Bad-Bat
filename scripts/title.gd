extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("start"):
		_on_start_button_pressed()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_select.tscn")
