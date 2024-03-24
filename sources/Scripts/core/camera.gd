extends Camera2D

@export var player_data : Resource
@export var top_position : Marker2D
@export var bottom_position : Marker2D

func _ready():
	limit_left = int(top_position.position.x)
	limit_top = int(top_position.position.y)
	limit_right = int(bottom_position.position.x)
	limit_bottom = int(bottom_position.position.y)

func _process(delta):
	global_position = player_data.global_position
