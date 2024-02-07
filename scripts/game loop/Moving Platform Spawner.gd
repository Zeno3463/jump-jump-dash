extends Node2D

### PUBLIC VARIABLES ###
@export var moving_platforms: Array[PackedScene]
@export var start_time = 1

### VARIABLES ###
var time = 0

### SYSTEM FUNCTIONS ###
func _process(delta):
	# spawn a moving platform every n seconds
	if time <= 0:
		_spawn_platform()
		time = start_time
	else: time -= delta

### PRIVATE FUNCTIONS ###
func _spawn_platform():
	# instantiate a new platform object
	var new_platform = moving_platforms.pick_random().instantiate()
	# randomize the starting position of the platform
	new_platform.global_position = Vector2(
		($"Upper bound".global_position.x + $"Lower bound".global_position.x) / 2,
		randf_range($"Upper bound".global_position.y, $"Lower bound".global_position.y)
	)
	# add the platform to the game
	add_child(new_platform)
