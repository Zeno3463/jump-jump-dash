extends Control

### System Functions ###
func _ready():
	# set up the navigation buttons
	for child in $Menu.get_children():
		if child is TextureButton:
			child.pressed.connect(Callable(_on_nav_button_pressed).bind(child.name))

func _on_nav_button_pressed(tab_name: String):
	# when a navigation button is pressed, switch to the designated tab
	get_parent().get_node(tab_name).visible = true
	visible = false


