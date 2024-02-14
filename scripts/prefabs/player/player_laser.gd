extends StaticBody2D

### Public Variables ###
@export var is_spike := false
@export var start_time = 0.1

### Variables ###
var on := false
var time = 0

### System Functions ###
func _process(delta):
	# if the laser/spike is not activated yet, do nothing
	if not on: return
	
	# if is laser, then maintain the rotation
	if not is_spike: global_rotation_degrees = 0
	# else if is spike, then rotate around
	else: global_rotation_degrees += delta * GlobalVariables.time_scale * 700
	
	# check overlapping area every n seconds
	if time <= 0:
		time = start_time
		for area in $Area2D.get_overlapping_areas():
			
			# if the area is an enemy, damage the enemy once if is laser, or if is spike then destroy the enemy entirely
			if area.get_parent() is MovingPlatforms and area.get_parent().is_enemy:
				if is_spike: area.get_parent().life = 1
				area.get_parent().take_damage()
			if area.get_parent() is EnemyBullet:
				if is_spike: area.get_parent().life = 1
				area.get_parent().take_damage()
	else:
		time -= delta * GlobalVariables.time_scale
