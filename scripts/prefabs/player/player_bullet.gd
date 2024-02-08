extends CharacterBody2D

@export var speed = 500
@export var lifetime = 1

func _process(delta):
	lifetime -= delta * GlobalVariables.time_scale
	if lifetime <= 0:
		queue_free()

func _physics_process(delta):
	velocity.x = speed * GlobalVariables.time_scale
	move_and_slide()
