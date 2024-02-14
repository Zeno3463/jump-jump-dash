extends MovingPlatforms

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if touches player and player is not in spike mode, damange the player
	if body is PlayerCLass:
		# if player is in spike mode however, destroy self
		if GlobalVariables.spike:
			life = 1
			take_damage()
		else: body.take_damage()

