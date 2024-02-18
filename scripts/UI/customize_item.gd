extends TextureButton

class_name CustomizeItem

### Public Variables ###
@export var item_name: String
@export var texture: Texture
@export var color: Color
@export var item_type: String

### System Functions ###
func _process(_delta):
	# set the texture and color of the item
	$TextureRect.texture = texture
	$TextureRect.modulate = color
	
	# if the item is selected, show the selected texture
	for n in GlobalVariables.selected_items:
		if n == item_name: $Selected.visible = true
