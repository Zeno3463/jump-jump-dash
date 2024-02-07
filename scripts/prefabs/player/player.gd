extends CharacterBody2D

class_name PlayerCLass

### CONSTANTS ###
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 800

### PUBLIC VARIABLES ###
@export var max_jump_count = 2
@export var player_dash_particle: PackedScene

### VARIABLES ###
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count := 0
var rotating := false
var dashing := false
var dir := Vector2.ZERO # keep track of the direction of rotation of the player when the player clicks the left mouse button
var mouse_pos_when_pressed := Vector2.ZERO # keep track of the original mouse position when the player clicks left mouse button

### SYSTEM FUNCTIONS ###
func _input(event):
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
	# if rotation is enabled
	if rotating:
		# make the screen darker when rotating
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D2, "modulate", Color8(0, 0, 0, 100), 0.1)
		# slow down time when rotating
		GlobalVariables.time_scale = 0.7
		# rotate the player according to the mouse movement
		dir = mouse_pos_when_pressed - get_global_mouse_position()
		rotation = atan2(dir.y, dir.x)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D2, "modulate", Color8(15, 15, 15, 0), 0.1)
		GlobalVariables.time_scale = 1

func _physics_process(delta):
	# add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# if on ground, then disable dashing and then initiate screen shake
	if dashing:
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			dashing = false
			get_parent().get_node("Camera2D").shake(50, 0.1, 50)

	# reset jump_count if on ground
	if is_on_floor():
		jump_count = 0

	# handle jump
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# disable horizontal movement if not dashing
	if not dashing: velocity.x = move_toward(velocity.x, 0, SPEED)

	if rotating: velocity *= GlobalVariables.time_scale

	move_and_slide()

### PRIVATE FUNCTIONS ###
func _dash_towards():
	var particle = player_dash_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	# enable dashing
	dashing = true
	# dynamically set the player velocity to dash towards the direction of rotation of the player
	velocity = Vector2.RIGHT.rotated(atan2(dir.y, dir.x)) * DASH_SPEED
