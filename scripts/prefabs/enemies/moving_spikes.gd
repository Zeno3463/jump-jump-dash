extends MovingPlatforms

### SYSTEM FUNCTIONS ###
func _on_area_2d_2_body_entered(body):
	# if touches player, damange the player
	if body is PlayerCLass: body.take_damage()
