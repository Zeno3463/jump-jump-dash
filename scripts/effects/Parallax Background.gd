extends Sprite2D

### PUBLIC VARIABLES ###
@export var parallax_multiplier = 0.0

### SYSTEM FUNCTIONS ###
func _process(delta):
	get_parent().modulate = GlobalVariables.get_color("BackgroundColor")
	
	# move the parallax object to the left with a certain speed multiplier
	position.x -= delta * parallax_multiplier * GlobalVariables.time_scale

	# if the object moves too far to the left, reset the position of the object
	if position.x <= -950:
		position.x = 950
