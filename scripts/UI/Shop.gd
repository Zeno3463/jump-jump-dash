extends Control

var selected_item: ShopItem
var selected_item_name := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is ShopItem:
			child.pressed.connect(Callable(_on_item_pressed).bind(child))

func _process(_delta):
	$Label2.text = "$" + str(GlobalVariables.coins)

func _on_item_pressed(item: ShopItem):
	if item.item_name in GlobalVariables.purchased_items:
		$CenterContainer2/Button.text = "Purchase"
		$CenterContainer2/Button.disabled = true
	else:
		$CenterContainer2/Button.text = item.item_name + " - Purchase"
		$CenterContainer2/Button.disabled = false
	selected_item = item
	selected_item_name = item.item_name

func _on_purchase_button_pressed():
	if not selected_item: return
	if GlobalVariables.coins >= selected_item.price:
		GlobalVariables.coins -= selected_item.price
		GlobalVariables.purchased_items.append(selected_item.item_name)
		selected_item = null
		selected_item_name = ""
	GlobalVariables.save_game()

func _on_texture_button_pressed():
	get_parent().get_node("Default").visible = true
	visible = false
