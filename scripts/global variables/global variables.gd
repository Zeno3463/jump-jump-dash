extends Node

### Game Loop ###
var start_game = false

### Time ###
var max_time_scale = 1
var slowed_down_time_scale = 0.7
var time_scale = 1
@onready var total_time = 0
@onready var total_enemy_killed = 0

### Current Weapon ###
var current_weapon := "Default"

### Game Data ###
var coins = 0
var purchased_items = [
	"Default", "Enemy Default", "Background Default"
]
var names_of_selected_items = {
	PlayerColor = "Default",
	EnemyColor = "Enemy Default",
	BackgroundColor = "Background Default"
}
var selected_items = {
	PlayerColor = "(0.729, 0.133, 0.322, 1)",
	EnemyColor = "(0.161, 0.427, 0.463, 1)",
	BackgroundColor = "(0.992, 0.8, 0.667, 1)"
}

### High Score System ###
# entry.588247483 - Name
# entry.889338148 - Distance
# entry.181793974 - Enemies Killed
const url_data = "https://opensheet.elk.sh/15qjV6ev1R-n9wT-KNXIAOasz1ELyXnjgakt4zQWxPkY/Data"
const url_submit = "https://docs.google.com/forms/u/2/d/e/1FAIpQLScpJz6xoqXl5ryKhOMRmaVJPKmRMbbdXJsRqkDVRJjxRU30dg/formResponse"
const headers = ["Content-Type: application/x-www-form-urlencoded"]
var client = HTTPClient.new()

### System Functions ###
func _ready():
	#clear_history()
	#save_game()
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
		names_of_selected_items = data["names_of_selected_items"]

func save_game():
	# open the existing user data file or create a new one
	var file = FileAccess.open("user://data.save", FileAccess.WRITE)
	
	# store all data in dictionary
	var data: Dictionary = {
		coins = coins,
		purchased_items = purchased_items,
		selected_items = selected_items,
		names_of_selected_items = names_of_selected_items
	}
	
	# store the dictionary as a string into the file
	file.store_string(JSON.stringify(data))
	file.close()
	
func clear_history():
	# delete user data
	DirAccess.remove_absolute("user://data.save")
	
func get_color(target: String) -> Color:
	if selected_items[target] is Color:
		return selected_items[target]
	else: 
		var col = selected_items[target].replace(" ", "").replace("(", "").replace(")", "").split(",")
		return Color(float(col[0]),float(col[1]),float(col[2]),float(col[3]))

func add_high_score(n: String):
	var http = HTTPRequest.new()
	http.connect("request_completed", self.http_submit.bind(http))
	add_child(http)
	
	var user_data = client.query_string_from_dict({
		"entry.588247483": n,
		"entry.889338148": snapped(total_time, 0.01),
		"entry.181793974": total_enemy_killed
	})
	var err = http.request(url_submit, headers, HTTPClient.METHOD_POST, user_data)
	if err: http.queue_free()
	else: print("sent")

func http_submit(_results, _response_code, _headers, _body, http):
	http.queue_free()
