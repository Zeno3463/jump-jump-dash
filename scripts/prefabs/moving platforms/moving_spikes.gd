extends MovingPlatforms

### SYSTEM VARIABLES ###
func _on_area_2d_2_body_entered(body):
	# if player hits the spike, make the player die
	if body is PlayerCLass:
		get_tree().reload_current_scene()
