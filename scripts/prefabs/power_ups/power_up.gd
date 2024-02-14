extends MovingPlatforms

### PUBLIC VARIABLES ###
enum PowerClass {PentaGunPowerUp, LaserPowerUp, SpikePowerUp}
@export var power_up: PowerClass

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if the player touches the power up, store the power up to be used later
	if body is PlayerCLass and not GlobalVariables.is_using_power_up:
		GlobalVariables.current_power_up = PowerClass.keys()[power_up]
		get_parent().get_parent().get_node("Player/CanvasLayer/TextureRect").texture = $Sprite2D.texture
		queue_free()
