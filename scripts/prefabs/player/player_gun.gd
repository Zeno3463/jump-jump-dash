extends Sprite2D

### PUBLIC VARIABLES ###
@export var start_time = 0.2
@export var bullet: PackedScene

### VARIABLES ###
var time := 0

### SYSTEM FUNCTIONS ###
func _process(delta):
	# disable all the weapons
	for child in get_children():
		if not child is AudioStreamPlayer:
			child.on = false
	
	# enable only the current acquired weapon
	if has_node(GlobalVariables.current_weapon): get_node(GlobalVariables.current_weapon).on = true

	# if the game has not started yet, don't shoot
	if not GlobalVariables.start_game: return
	
	# initiate shooting every n seconds
	if time <= 0 and (GlobalVariables.current_weapon == "" or GlobalVariables.current_weapon == "PentaGun"):
		_shoot()
		@warning_ignore("narrowing_conversion")
		time = start_time
	else:
		time -= delta * GlobalVariables.time_scale

### PRIVATE FUNCTIONS ###
func _shoot():
	# if the penta gun weapon is not acquired
	if not GlobalVariables.current_weapon == "PentaGun":
		# shoot one bullet to the right
		var new_bullet := bullet.instantiate()
		new_bullet.global_position = global_position
		get_parent().get_parent().add_child(new_bullet)
	
	# if the penta gun weapon is acquired
	else:
		# shoot 5 bullets at 5 different angles to the right
		var angles := [-75, -45, 0, 45, 75]
		for angle in angles:
			var new_bullet: CharacterBody2D = bullet.instantiate()
			new_bullet.scale = Vector2.ONE * 0.5
			new_bullet.global_position = global_position
			new_bullet.rotation_degrees = angle
			get_parent().get_parent().add_child(new_bullet)
	
	$AudioStreamPlayer.play()
