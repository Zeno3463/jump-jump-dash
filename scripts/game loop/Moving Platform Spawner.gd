extends Node2D

### PUBLIC VARIABLES ###
@export var moving_platforms: Array[PackedScene]
@export var start_time = 1

### VARIABLES ###
var time = 0
var spawn_count = 0

### SYSTEM FUNCTIONS ###
func _process(delta):
	# spawn a moving platform every n seconds
	if time <= 0:
		_spawn_platform()
		time = start_time
	else: time -= delta * GlobalVariables.time_scale
	
	# TODO: Speed up the gameplay over time
	'''
	if spawn_count % 10 == 0:
		spawn_count = 0
		var tween = get_tree().create_tween()
		var max_time_scale = GlobalVariables.max_time_scale
		var slowed_down_time_scale = GlobalVariables.slowed_down_time_scale
		tween.tween_property(GlobalVariables, "max_time_scale", max_time_scale + 0.5, 10)
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(GlobalVariables, "slowed_down_time_scale", slowed_down_time_scale + 0.5, 10)
	'''

### PRIVATE FUNCTIONS ###
func _spawn_platform():
	# instantiate a new platform object
	spawn_count += 1
	var new_platform = moving_platforms.pick_random().instantiate()
	# randomize the starting position of the platform
	new_platform.global_position = Vector2(
		($"Upper bound".global_position.x + $"Lower bound".global_position.x) / 2,
		randf_range($"Upper bound".global_position.y, $"Lower bound".global_position.y)
	)
	# add the platform to the game
	add_child(new_platform)
