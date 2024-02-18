extends Control

### System Functions ###
func _ready():
	# add all the purchased item into the option
	for item in GlobalVariables.purchased_items:
		pass
	for child in get_children():
		if child is CustomizeItem:
			child.pressed.connect(Callable(_on_item_pressed).bind(child))

func _on_item_pressed(item: CustomizeItem):
	# equip the item and save the game when the player clicks on it
	GlobalVariables.selected_items[item.item_type] = item.item_name
	GlobalVariables.save_game()

func _on_texture_button_pressed():
	# exit to default menu screen when exit button is pressed
	get_parent().get_node("Default").visible = true
	visible = false
