extends Sprite2D

@export var start_time = 0.2
@export var bullet: PackedScene

var time = 0

func _process(delta):
	if time <= 0:
		_shoot()
		time = start_time
	else:
		time -= delta * GlobalVariables.time_scale

func _shoot():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = global_position
	get_parent().get_parent().add_child(new_bullet)
