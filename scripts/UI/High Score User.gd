extends Control

var username
var val

func _process(_delta):
	$Label.text = username
	$Label2.text = str(val)
