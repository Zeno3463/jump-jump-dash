extends StaticBody2D

class_name MovingPlatforms

### PUBLIC VARIABLES ###
@export var speed = 300
@export var is_enemy = false
@export var enemy_life = 3

### VARIABLES ###
@onready var original_color = get_node("Sprite2D").modulate
@onready var enemy_damage_particle = preload("res://scenes/effects/enemy_damage_particle.tscn")
@onready var life = enemy_life

### SYSTEM FUNCTIONS ###
func _process(delta):
	# move to the left
	global_position.x -= speed * delta * GlobalVariables.time_scale
	
	# TODO determine whether if the platform moved too far according to the window width
	# if the platform moved too far to the left, destroy the platform
	if global_position.x <= -800:
		queue_free()
		
	if is_enemy:
		modulate = GlobalVariables.get_color("EnemyColor")

### PUBLIC FUNCTIONS ###
func take_damage():
	# emit explosion effect
	var particle = enemy_damage_particle.instantiate()
	particle.global_position = global_position
	get_parent().add_child(particle)
	particle.emitting = true
	
	# enable screen shake
	get_parent().get_parent().get_node("Camera2D").shake(170, 0.3, 170)
	
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load("res://audio/hitHurt.wav")
	add_child(audio_player)
	audio_player.play()
	
	# take out one life from the enemy
	life -= 1
	
	# if the enemy has no life, destroy the enemy
	if life == 0:
		GlobalVariables.coins += 1
		await audio_player.finished
		queue_free()
		return
		
	# set the transparency of the enemy according to its life (full life = fully opaque, 1 life left = less transparent)
	get_node("Sprite2D").self_modulate = Color8(255, 255, 255, int(255 * 0.65 ** (enemy_life - life)))

	# flash out a white color on the enemy sprite for 0.1 second
	get_node("Sprite2D").modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	get_node("Sprite2D").modulate = original_color

