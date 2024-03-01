extends Camera2D

@export var top_position : Marker2D
@export var bottom_position : Marker2D

func _ready():
	limit_left = top_position.position.x;
	limit_top = top_position.position.y;
	limit_right = bottom_position.position.x;
	limit_bottom = bottom_position.position.y;
