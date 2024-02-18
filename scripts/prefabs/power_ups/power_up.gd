extends MovingPlatforms

### PUBLIC VARIABLES ###
enum WeaponClass {PentaGun, Laser, Spike}
@export var weapon: WeaponClass

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if the player touches the power up, store the power up to be used later
	if body is PlayerCLass:
		GlobalVariables.current_weapon = WeaponClass.keys()[weapon]
		get_parent().get_parent().get_node("Player/CanvasLayer/TextureRect").texture = $Sprite2D.texture
		queue_free()
