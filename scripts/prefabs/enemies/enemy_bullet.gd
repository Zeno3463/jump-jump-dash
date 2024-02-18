extends CharacterBody2D

class_name EnemyBullet

### PUBLIC VARIABLES ###
@export var speed = 500
@export var lifetime = 10
@export var enemy_life = 3
@export var is_projectile = false

### VARIABLES ###
@onready var original_color = $Sprite2D.modulate
@onready var life = enemy_life
@onready var enemy_damage_particle = preload("res://scenes/effects/enemy_damage_particle.tscn")

### SYSTEM FUNCTIONS ###
func _process(delta):
	# after the bullet's lifetime has ended, destroy the bullet
	lifetime -= delta * GlobalVariables.time_scale
	if lifetime <= 0: queue_free()

func _physics_process(delta):
	# move towards player with a designated speed
	if not is_projectile: velocity = (get_parent().get_node("Player").global_position - global_position).normalized() * speed * delta * GlobalVariables.time_scale
	else: velocity = Vector2.LEFT * delta * speed * GlobalVariables.time_scale
	move_and_slide()

func _on_area_2d_body_entered(body):
	# if touches player, damange the player
	if body is PlayerCLass: body.take_damage()

### PUBLIC FUNCTIONS ###
func take_damage():
	# emit explosion effect
	var particle = enemy_damage_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	
	# enable screen shake
	get_parent().get_node("Camera2D").shake(170, 0.3, 170)
	
	# take out one life from the enemy
	life -= 1
	
	# if the enemy has no life, destroy the enemy
	if life == 0:
		GlobalVariables.coins += 1
		queue_free()
		return
	
	# set the transparency of the enemy according to its life (full life = fully opaque, 1 life left = less transparent)
	get_node("Sprite2D").self_modulate = Color8(255, 255, 255, int(255 * 0.65 ** (enemy_life - life)))
	
	# flash out a white color on the enemy sprite for 0.1 second
	$Sprite2D.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = original_color
