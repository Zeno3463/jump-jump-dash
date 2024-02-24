extends TextureButton

class_name ShopItem

enum ItemClass {PlayerColor, BackgroundColor, EnemyColor}
@export var item_class: ItemClass

@export var item_name: String
@export var price: int
@export var texture: Texture
@export var color: Color

func _process(_delta):
	$TextureRect.texture = texture
	$TextureRect.modulate = color
	$Label.text = "$" + str(price)
	if get_parent().selected_item_name == item_name:
		$ColorRect.visible = true
		for n in GlobalVariables.purchased_items:
			if n == item_name:
				$Purchased.visible = true
				$ColorRect.visible = false
				equip_current_item()
	else:
		$ColorRect.visible = false
		$Purchased.visible = false
		
	for n in GlobalVariables.names_of_selected_items:
		if GlobalVariables.names_of_selected_items[n] == item_name:
			$Purchased.visible = true
			$ColorRect.visible = false
	
func equip_current_item():
	GlobalVariables.selected_items[ItemClass.keys()[item_class]] = color
	GlobalVariables.names_of_selected_items[ItemClass.keys()[item_class]] = item_name
	GlobalVariables.save_game()

