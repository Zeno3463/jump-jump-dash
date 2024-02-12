extends MovingPlatforms

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if the player touches the power up
	if body is PlayerCLass:
		# stop moving to the left
		moving = false
		
		# disable the collision shape to prevent this function to be trigerred again
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
		# hide the sprite
		$Sprite2D.visible = false
		
		# initiate power up for 8 seconds, then queue free
		GlobalVariables.penta_gun = true
		await get_tree().create_timer(8).timeout
		GlobalVariables.penta_gun = false
		queue_free()
