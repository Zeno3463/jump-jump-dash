extends Control

const url_data = "https://opensheet.elk.sh/15qjV6ev1R-n9wT-KNXIAOasz1ELyXnjgakt4zQWxPkY/Data"
const headers = ["Content-Type: application/x-www-form-urlencoded"]

@onready var user_instance = preload("res://scenes/UI/high score/high_score_user.tscn")

var time_alive_array = []
var enemies_killed_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var http = HTTPRequest.new()
	http.connect("request_completed", self.http_done.bind(http))
	add_child(http)
	
	var err = http.request(url_data, headers, HTTPClient.METHOD_GET)
	if err: http.queue_free()

func http_done(_result, _response_code, _headers, _body, http):
	http.queue_free()
	if !_result:
		var data = JSON.parse_string(_body.get_string_from_utf8())
		var i = 10
		for n in data:
			if i <= 0: break
			i -= 1
			var time_alive = user_instance.instantiate()
			time_alive.username = n["Name"]
			time_alive.val = float(n["Distance Travelled"])
			time_alive_array.append(time_alive)
			
			var enemies_killed = user_instance.instantiate()
			enemies_killed.username = n["Name"]
			enemies_killed.val = float(n["Enemies Killed"])
			enemies_killed_array.append(enemies_killed)
		time_alive_array.sort_custom(_array_sort)
		enemies_killed_array.sort_custom(_array_sort)
		for child in time_alive_array: $"CenterContainer2/Control/Time Alive".add_child(child)
		for child in enemies_killed_array: $"CenterContainer2/Control/Enemies Killed".add_child(child)

func _on_texture_button_pressed():
	get_parent().get_node("Default").visible = true
	visible = false

func _array_sort(a, b):
	return a.val > b.val
