extends Line2D

### PUBLIC VARIABLES ###
@export var trail_length = 10
@onready var point = get_parent().global_position

### VARIABLES ###
var leave_tracks = true

### SYSTEM FUNCTIONS ###
func _ready():
	set_as_top_level(true)
	if get_point_count() > 0: remove_point(0)

func _physics_process(_delta):
	if leave_tracks:
		point = get_parent().global_position
		add_point(point)
		if points.size() > trail_length:
			remove_point(0)
	else:
		if points.size():
			remove_point(0)
