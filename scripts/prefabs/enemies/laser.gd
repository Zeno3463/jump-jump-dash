extends MovingPlatforms

func _on_area_2d_body_entered(body):
	if body is PlayerCLass:
		get_tree().reload_current_scene()
