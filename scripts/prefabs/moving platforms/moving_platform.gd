extends StaticBody2D

class_name MovingPlatforms

### PUBLIC VARIABLES
@export var speed = 300

### SYSTEM FUNCTIONS ###
func _process(delta):
	# move to the left
	global_position.x -= speed * delta * GlobalVariables.time_scale
	
	if global_position.x <= -800:
		queue_free()
