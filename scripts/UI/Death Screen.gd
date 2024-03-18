extends CanvasLayer

var submitted = false

func _process(delta):
	if submitted:
		$"Death Screen/CenterContainer/VBoxContainer/LineEdit".text = ""
		$"Death Screen/CenterContainer/VBoxContainer/Button".text = "submitted"
		$"Death Screen/CenterContainer/VBoxContainer/Button".disabled = true

func _on_home_pressed():
	submitted = false
	get_tree().reload_current_scene()

func _on_button_pressed():
	if not submitted:
		GlobalVariables.add_high_score($"Death Screen/CenterContainer/VBoxContainer/LineEdit".text)
		submitted = true
