extends CharacterBody2D

### PUBLIC VARIABLES ###
@export var speed = 500
@export var lifetime = 10

### SYSTEM VARIABLES ###
func _process(delta):
	# after the bullet's lifetime has ended, destroy the bullet
	lifetime -= delta * GlobalVariables.time_scale
	if lifetime <= 0: queue_free()

func _physics_process(delta):
	# move towards player with a designated speed
	velocity = (get_parent().get_node("Player").global_position - global_position).normalized() * speed * GlobalVariables.time_scale
	move_and_slide()

func _on_area_2d_body_entered(body):
	# if player hits the bullet, make the player die
	if body is PlayerCLass: get_tree().reload_current_scene()
