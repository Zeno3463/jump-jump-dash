extends CharacterBody2D

class_name PlayerCLass

### CONSTANTS ###
const SPEED = 300.0
const JUMP_VELOCITY = -650.0
const DASH_SPEED = 600

### PUBLIC VARIABLES ###
@export var player_dash_particle: PackedScene
@export var player_power_up_particle: PackedScene
@export var max_life = 3

### VARIABLES ###
@onready var original_color = $WhiteSquare.modulate
@onready var life = max_life
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count := 0
var rotating := false
var dashing := false
var dir := Vector2.ZERO # keep track of the direction of rotation of the player when the player clicks the left mouse button
var mouse_pos_when_pressed := Vector2.ZERO # keep track of the original mouse position when the player clicks left mouse button
var activate_power_up := false

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
	if not GlobalVariables.start_game: return
	
	for child in $CanvasLayer/Hearts.get_children():
		child.queue_free()
	for i in range(life):
		var heart = TextureRect.new()
		heart.texture = preload("res://sprites/UI/heart.png")
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		$CanvasLayer/Hearts.add_child(heart)
	
	# if rotation is enabled
	if rotating:
		# activate power up if the jump jump dash sequence is achieved
		if jump_count == 2 and GlobalVariables.current_power_up != "":
			activate_power_up = true
			$WhiteSquare.modulate = Color.WHITE
			$Light.visible = true
		else:
			$Light.visible = false
			$WhiteSquare.modulate = original_color
			activate_power_up = false
			jump_count = 0
		
		# make the screen darker when rotating
		var tween := get_tree().create_tween()
		tween.tween_property($Sprite2D2, "modulate", Color8(0, 0, 0, 100), 0.1)
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
		
		# speed up the time to the original speed of time
		GlobalVariables.time_scale = GlobalVariables.max_time_scale

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
			get_parent().add_child(particle)
			particle.emitting = true

	# handle jump
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		if jump_count > 2: jump_count = 2

	# disable horizontal movement if not dashing
	if not dashing and is_on_floor(): velocity.x = move_toward(velocity.x, 0, SPEED)

	# slow down the velocity of the player if the player is rotating
	if rotating: velocity *= 0.7

	move_and_slide()

# when the touch screen jump button is pressed, initiate jump
func _on_texture_button_pressed():
	if not GlobalVariables.start_game: return
	
	velocity.y = JUMP_VELOCITY
	jump_count += 1

### PUBLIC FUNCTIONS ###
func take_damage():
	life -= 1
	get_tree().paused = true
	$WhiteSquare.modulate = Color.WHITE
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	$WhiteSquare.modulate = original_color
	if life < 0:
		get_tree().reload_current_scene()

### PRIVATE FUNCTIONS ###
func _dash_towards():
	if activate_power_up: _activate_power_up()
	
	# initiate screen shake
	get_parent().get_node("Camera2D").shake(100, 0.4, 100)
	
	# emit dash particle
	var particle = player_dash_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	
	# enable dashing
	dashing = true
	# dynamically set the player velocity to dash towards the direction of rotation of the player
	velocity = Vector2.RIGHT.rotated(atan2(dir.y, dir.x)) * DASH_SPEED

func _activate_power_up():
	var particle = player_power_up_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	$Light.visible = false
	$CanvasLayer/TextureRect.texture = null
	$WhiteSquare.modulate = original_color
	activate_power_up = false
	jump_count = 0
	match GlobalVariables.current_power_up:
		"PentaGunPowerUp":
			GlobalVariables.is_using_power_up = true
			GlobalVariables.penta_gun = true
			await get_tree().create_timer(8).timeout
			GlobalVariables.penta_gun = false
			GlobalVariables.is_using_power_up = false
		"LaserPowerUp":
			GlobalVariables.is_using_power_up = true
			GlobalVariables.laser = true
			await get_tree().create_timer(8).timeout
			GlobalVariables.laser = false
			GlobalVariables.is_using_power_up = false
		"SpikePowerUp":
			GlobalVariables.is_using_power_up = true
			GlobalVariables.spike = true
			await get_tree().create_timer(8).timeout
			GlobalVariables.spike = false
			GlobalVariables.is_using_power_up = false
	GlobalVariables.current_power_up = ""
