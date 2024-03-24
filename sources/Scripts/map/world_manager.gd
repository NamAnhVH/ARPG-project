extends Node2D
class_name WorldManager

@export var player_data : Resource
@export var world_data : Resource

func _ready():
	SignalManager.change_map.connect(_on_change_map)
	world_data.changed.connect(_on_changed_map)
	_on_change_map(world_data.current_map, player_data.global_position)

func _on_change_map(world_id, location):
	if get_children().size() > 1:
		get_child(1).queue_free()
	var current_map = ResourceManager.get_map(world_id)
	player_data.global_position = location
	world_data.current_map = world_id
	call_deferred("add_child", current_map)

func _on_changed_map():
	if get_children().size() > 1:
		get_child(1).queue_free()
	var current_map = ResourceManager.get_map(world_data.current_map)
	call_deferred("add_child", current_map)
