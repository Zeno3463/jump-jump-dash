extends MovingPlatforms

### PUBLIC VARIABLES ###
enum WeaponClass {PentaGun, Laser, Spike, Trilaser, Default}
@export var weapon: WeaponClass

### SYSTEM FUNCTIONS ###
func _on_area_2d_body_entered(body):
	# if the player touches the power up, store the power up to be used later
	if body is PlayerCLass:
		GlobalVariables.current_weapon = WeaponClass.keys()[weapon]
		get_parent().get_parent().get_node("Player/CanvasLayer/TextureRect").texture = $Sprite2D.texture
		body.new_weapon_effect()
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = load("res://audio/powerUp.wav")
		add_child(audio_player)
		audio_player.play()
		visible = false
		await audio_player.finished
		queue_free()
