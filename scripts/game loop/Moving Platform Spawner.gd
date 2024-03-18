extends Node2D

### PUBLIC VARIABLES ###
@export var moving_platforms: Array[PackedScene]
@export var start_time = 1
@export var time_btw_level = 20

### VARIABLES ###
var time = 0
@onready var level_time = time_btw_level

### SYSTEM FUNCTIONS ###
func _process(delta):
	if not GlobalVariables.start_game: return
	
	GlobalVariables.total_time += delta * GlobalVariables.time_scale
	
	# spawn a moving platform every n seconds
	if time <= 0:
		_spawn_platform()
		time = start_time
	else: time -= delta * GlobalVariables.time_scale
	
	# speed up the gameplay over time
	if level_time <= 0:
		level_time = time_btw_level
		GlobalVariables.max_time_scale += 0.1
		GlobalVariables.slowed_down_time_scale += 0.1
		GlobalVariables.time_scale += 0.1
	else:
		level_time -= delta * GlobalVariables.time_scale

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
