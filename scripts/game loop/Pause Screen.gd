extends Control

### System Functions ###
func _on_button_pressed():
	# when the player clicks anywhere in pause mode, resume the game
	get_tree().paused = false
	visible = false

func _on_pause_button_pressed():
	# when the player clicks the pause button, pause the game
	get_tree().paused = true
	visible = true
