extends MovingPlatforms

### PUBLIC VARIABLES ###
@export var bullet: PackedScene
@export var start_time = 1

### VARIABLES ###
var time = 0

### SYSTEM VARIABLES ###
func _physics_process(delta):
	# initiate shooting every n seconds
	if time <= 0:
		_shoot()
		time = start_time
	else: time -= delta

### PRIVATE VARIABLES
func _shoot():
	# shoot a new bullet towards the player
	var new_bullet: CharacterBody2D = bullet.instantiate()
	new_bullet.global_position = global_position
	get_parent().get_parent().add_child(new_bullet)
