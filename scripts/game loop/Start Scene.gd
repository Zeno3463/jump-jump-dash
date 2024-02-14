extends CanvasLayer

### System Functions ###
func _on_button_pressed():
	# when the player clicks anywhere, start the game
	GlobalVariables.start_game = true
	queue_free()
