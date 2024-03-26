extends Node2D
class_name WorldManager

@export var player_data : PlayerData
@export var world_data : WorldData

func _ready():
	SignalManager.change_map.connect(_on_change_map)
	world_data.changed.connect(_on_changed_map)
	_on_change_map(world_data.current_map, player_data.global_position, player_data.z_index)

func _on_change_map(world_id, location, player_z_index):
	if get_children().size() > 0:
		get_child(0).queue_free()
	var current_map = ResourceManager.get_map(world_id)
	player_data.global_position = location
	player_data.z_index = player_z_index
	world_data.current_map = world_id
	call_deferred("add_child", current_map)
	Global.current_map = current_map

func _on_changed_map():
	if get_children().size() > 0:
		get_child(0).queue_free()
	var current_map = ResourceManager.get_map(world_data.current_map)
	call_deferred("add_child", current_map)
	Global.current_map = current_map
