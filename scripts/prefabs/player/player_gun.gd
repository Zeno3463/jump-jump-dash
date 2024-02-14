extends Sprite2D

### PUBLIC VARIABLES ###
@export var start_time = 0.2
@export var bullet: PackedScene

### VARIABLES ###
var time := 0

### SYSTEM FUNCTIONS ###
func _process(delta):
	# if laser mode is activated, show the laser, else hide it
	if GlobalVariables.laser:
		$"Player Laser".on = true
		$"Player Laser".visible = true
		return
	else:
		$"Player Laser".on = false
		$"Player Laser".visible = false
	
	# if spike mode is activated, show the spike, else hide it
	if GlobalVariables.spike:
		$"Player Spike".on = true
		$"Player Spike".visible = true
		return
	else:
		$"Player Spike".on = false
		$"Player Spike".visible = false
	
	# if the game has not started yet, don't shoot
	if not GlobalVariables.start_game: return
	
	# initiate shooting every n seconds
	if time <= 0:
		_shoot()
		@warning_ignore("narrowing_conversion")
		time = start_time
	else:
		time -= delta * GlobalVariables.time_scale

### PRIVATE FUNCTIONS ###
func _shoot():
	# if the penta gun power up is not acquired
	if not GlobalVariables.penta_gun:
		# shoot one bullet to the right
		var new_bullet := bullet.instantiate()
		new_bullet.global_position = global_position
		get_parent().get_parent().add_child(new_bullet)
	
	# if the penta gun power up is acquired
	else:
		# shoot 5 bullets at 5 different angles to the right
		var angles := [-75, -45, 0, 45, 75]
		for angle in angles:
			var new_bullet: CharacterBody2D = bullet.instantiate()
			new_bullet.global_position = global_position
			new_bullet.rotation_degrees = angle
			get_parent().get_parent().add_child(new_bullet)
