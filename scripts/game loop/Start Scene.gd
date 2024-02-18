extends CanvasLayer

### System Functions ###
func _process(delta):
	$Default/Menu/Label.text = "$" + str(GlobalVariables.coins)

func _on_button_pressed():
	# when the player clicks anywhere, start the game
	GlobalVariables.start_game = true
	queue_free()

func _on_texture_button_pressed():
	GlobalVariables.clear_history()
