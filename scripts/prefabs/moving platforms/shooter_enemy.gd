extends MovingPlatforms

### PUBLIC VARIABLES ###
@export var bullet: PackedScene
@export var start_time = 1
@export var start_time_random = 0.5

### VARIABLES ###
var time = 0

### SYSTEM FUNCTIONS ###
func _physics_process(delta):
	# initiate shooting every n seconds
	if time <= 0:
		_shoot()
		time = randf_range(start_time - start_time_random, start_time + start_time_random)
	else: time -= delta

### PRIVATE FUNCTIONS ###
func _shoot():
	# shoot a new bullet towards the player
	var new_bullet: CharacterBody2D = bullet.instantiate()
	new_bullet.global_position = global_position
	get_parent().get_parent().add_child(new_bullet)
