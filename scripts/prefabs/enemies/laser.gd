extends MovingPlatforms

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if player touches the laser, reset the game
	if body is PlayerCLass:
		get_tree().reload_current_scene()
