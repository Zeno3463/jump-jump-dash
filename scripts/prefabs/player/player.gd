extends CharacterBody2D

class_name PlayerCLass

### CONSTANTS ###
const SPEED = 300.0
const JUMP_VELOCITY = -650.0
const DASH_SPEED = 900

### PUBLIC VARIABLES ###
@export var player_dash_particle: PackedScene
@export var player_power_up_particle: PackedScene
@export var player_die_particle: PackedScene
@export var max_life = 3

### VARIABLES ###
@onready var life = max_life
var gravity = 1500
var rotating := false
var dashing := false
var dir := Vector2.ZERO # keep track of the direction of rotation of the player when the player clicks the left mouse button
var mouse_pos_when_pressed := Vector2.ZERO # keep track of the original mouse position when the player clicks left mouse button

### SYSTEM FUNCTIONS ###
func _ready():
	# reset the time scale for the game
	GlobalVariables.max_time_scale = 1
	GlobalVariables.slowed_down_time_scale = 0.7

func _unhandled_input(event):
	if not GlobalVariables.start_game: return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# If the left mouse button is pressed
		if event.is_pressed():
			# set the mouse_pos_when_pressed vector if it has not been set yet
			if mouse_pos_when_pressed == Vector2.ZERO:
				mouse_pos_when_pressed = get_global_mouse_position()
			# show the drag line
			$"Drag Line".visible = true
			# enable player rotation
			rotating = true
		# If the left mouse button is released
		else:
			# hide the drag line
			$"Drag Line".visible = false
			# disable player rotation
			rotating = false
			# reset mouse_pos_when_pressed
			mouse_pos_when_pressed = Vector2.ZERO
			# dash towards the direction of rotation of the player
			_dash_towards()

func _process(_delta):
	modulate = GlobalVariables.get_color("PlayerColor")
	# hide the player UI (jump button, pause button) if the game hasn't started
	if not GlobalVariables.start_game:
		$CanvasLayer.visible = false
		return
	else:
		$CanvasLayer.visible = true
	
	# display the life of the player with heart textures
	for child in $CanvasLayer/Hearts.get_children():
		child.queue_free()
	for i in range(life):
		var heart = TextureRect.new()
		heart.texture = preload("res://sprites/UI/heart.png")
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		$CanvasLayer/Hearts.add_child(heart)
	
	# if rotation is enabled
	if rotating:
		# make the screen darker when rotating
		var tween := get_tree().create_tween()
		tween.tween_property($Sprite2D2, "modulate", Color8(0, 0, 0, 100), 0.1)
		$Light.modulate = Color8(255, 255, 255, 170)
		# slow down time when rotating
		GlobalVariables.time_scale = GlobalVariables.slowed_down_time_scale
		# rotate the player according to the mouse movement
		dir = mouse_pos_when_pressed - get_global_mouse_position()
		rotation = atan2(dir.y, dir.x)
	# else if rotation is disabled
	else:
		# revert the brightness of the screen
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D2, "modulate", Color8(15, 15, 15, 0), 0.1)
		$Light.modulate = Color8(255, 255, 255, 70)
		
		# speed up the time to the original speed of time
		GlobalVariables.time_scale = GlobalVariables.max_time_scale
	
	$"Death Screen/Death Screen/CenterContainer/VBoxContainer/Distance".text = "Time alive: " + str(snapped(GlobalVariables.total_time, 0.01))
	$"Death Screen/Death Screen/CenterContainer/VBoxContainer/Enemies Killed".text = "Enemies killed: " + str(GlobalVariables.total_enemy_killed)

func _physics_process(delta):
	if not GlobalVariables.start_game: return
	
	# add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# if on ground, then disable dashing
	if dashing:
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			dashing = false
			
			# initiate screen shake
			get_parent().get_node("Camera2D").shake(150, 0.2, 150)
			
			# emit dash particle
			var particle = player_dash_particle.instantiate()
			particle.global_position = global_position
			particle.modulate = GlobalVariables.get_color("PlayerColor")
			get_parent().add_child(particle)
			particle.emitting = true

	# handle jump
	if Input.is_action_just_pressed("ui_up"): velocity.y = JUMP_VELOCITY

	# lerp horizontal movement to 0 if not dashing
	if not dashing and is_on_floor(): velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)

	# slow down the velocity of the player if the player is rotating
	if rotating: velocity *= 0.7

	move_and_slide()

# when the touch screen jump button is pressed, initiate jump
func _on_texture_button_button_down():
	if not GlobalVariables.start_game: return
	
	velocity.y = JUMP_VELOCITY

### PUBLIC FUNCTIONS ###
func take_damage():
	life -= 1

	# flash a white color on the player texture, while pausing the game for a short moment
	get_tree().paused = true
	modulate = Color.WHITE
	await get_tree().create_timer(0.4).timeout
	get_tree().paused = false
	modulate = GlobalVariables.get_color("PlayerColor")
	
	# if player runs out of life, go back to menu screen
	if life <= 0:
		_die()

### PRIVATE FUNCTIONS ###
func _die():
	GlobalVariables.save_game()
	GlobalVariables.start_game = false

	get_parent().get_node("Camera2D").shake(150, 5, 150)
	
	$WhiteSquare.visible = false
	$"Player Gun".visible = false
	
	var particle: CPUParticles2D = player_die_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	
	await get_tree().create_timer(1).timeout
	
	$"Death Screen".visible = true

func _dash_towards():
	$AudioStreamPlayer.play()
	
	# initiate screen shake
	get_parent().get_node("Camera2D").shake(250, 0.4, 250)
	
	# emit dash particle
	var particle = player_dash_particle.instantiate()
	particle.global_position = global_position
	particle.modulate = GlobalVariables.get_color("PlayerColor")
	get_parent().add_child(particle)
	particle.emitting = true
	
	# enable dashing
	dashing = true
	
	# dynamically set the player velocity to dash towards the direction of rotation of the player
	velocity = Vector2.RIGHT.rotated(atan2(dir.y, dir.x)) * DASH_SPEED

### PUBLIC FUNCTIONS ###
func new_weapon_effect():
	# emit new weapon particle
	get_parent().get_node("Camera2D").shake(500, 0.7, 500)
	var particle = player_power_up_particle.instantiate()
	particle.global_position = global_position
	particle.modulate = GlobalVariables.get_color("PlayerColor")
	get_parent().add_child(particle)
	particle.emitting = true
