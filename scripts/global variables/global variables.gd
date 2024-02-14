extends Node

### Game Loop ###
var start_game = false

### Time ###
var max_time_scale = 1
var slowed_down_time_scale = 0.7
var time_scale = 1

### Power Ups ###
var current_power_up := ""
var is_using_power_up := false
var penta_gun := false
var laser := false
var spike := false
