extends TextureButton

class_name ShopItem

@export var item_name: String
@export var price: int
@export var texture: Texture
@export var color: Color

func _process(_delta):
	$TextureRect.texture = texture
	$TextureRect.modulate = color
	$Label.text = "$" + str(price)
	if get_parent().selected_item_name == item_name: $ColorRect.visible = true
	else: $ColorRect.visible = false
	
	for n in GlobalVariables.purchased_items:
		if n == item_name: $Purchased.visible = true
