extends StaticBody2D

class_name MovingPlatforms

### PUBLIC VARIABLES
@export var speed = 300

### SYSTEM VARIABLES ###
func _process(delta):
	# move to the left
	global_position.x -= speed * delta * GlobalVariables.time_scale
