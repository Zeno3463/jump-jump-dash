extends Node

### Game Loop ###
var start_game = false

### Time ###
var max_time_scale = 1
var slowed_down_time_scale = 0.7
var time_scale = 1

### Current Weapon ###
var current_weapon := ""

### Game Data ###
var coins = 0
var purchased_items = []
var selected_items = {
	skin_color = "default"
}

### System Functions ###
func _ready():
	load_game()

### Public Functions ###
func load_game():
	# if there are existing user data
	if FileAccess.file_exists("user://data.save"):
		# load the user data and convert it to JSON
		var file = FileAccess.open("user://data.save", FileAccess.READ)
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		file.close()
		
		# use the JSON data to dynamically set each of the user variables
		coins = data["coins"]
		purchased_items = data["purchased_items"]
		selected_items = data["selected_items"]

func save_game():
	# open the existing user data file or create a new one
	var file = FileAccess.open("user://data.save", FileAccess.WRITE)
	
	# store all data in dictionary
	var data: Dictionary = {
		coins = coins,
		purchased_items = purchased_items,
		selected_items = selected_items
	}
	
	# store the dictionary as a string into the file
	file.store_string(JSON.stringify(data))
	file.close()
	
func clear_history():
	# delete user data
	DirAccess.remove_absolute("user://data.save")

