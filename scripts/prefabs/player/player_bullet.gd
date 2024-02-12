extends CharacterBody2D

### PUBLIC VARIABLES ###
@export var speed = 500
@export var lifetime = 1

### SYSTEM FUNCTIONS ###
func _process(delta):
	# after lifetime seconds, destroy the bullet
	lifetime -= delta * GlobalVariables.time_scale
	if lifetime <= 0: queue_free()

func _physics_process(delta):
	# move according to the angle of rotation
	velocity = Vector2(cos(rotation_degrees), sin(rotation_degrees)) * delta * speed * GlobalVariables.time_scale
	move_and_slide()

func _on_area_2d_area_entered(area):
	# if the bullet collides with an enemy, damage the enemy and destroy the bullet
	if area.get_parent() is MovingPlatforms and area.get_parent().is_enemy:
		area.get_parent().take_damage()
		queue_free()
	if area.get_parent() is EnemyBullet:
		area.get_parent().take_damage()
		queue_free()
