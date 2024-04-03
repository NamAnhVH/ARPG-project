extends Node2D
class_name WorldManager

@export var player_data : PlayerData
@export var world_data : WorldData

func _ready():
	SignalManager.change_world.connect(_on_change_world)
	SignalManager.change_map.connect(_on_change_map)
	world_data.changed.connect(_on_loaded_game)
	_on_start_game(world_data.current_map, player_data.global_position, player_data.z_index)

func _on_start_game(map_id, location, player_z_index):
	SignalManager.clear_hidden_node.emit()
	SignalManager.inventory_closed.emit()
	var current_map = ResourceManager.get_map(map_id)
	call_deferred("add_child", current_map)
	Global.current_map = current_map
	generate_world(current_map)

func _on_change_map(map_id):
	var current_map
	for map: Map in get_children():
		if map.map_id == map_id:
			current_map = map
	world_data.current_map = map_id
	Global.current_map = current_map
	generate_world(current_map)

func _on_change_world(map_id, location, player_z_index):
	SignalManager.clear_hidden_node.emit()
	SignalManager.inventory_closed.emit()
	for map in get_children():
		map.queue_free()
	var current_map = ResourceManager.get_map(map_id)
	player_data.global_position = location
	player_data.z_index = player_z_index
	world_data.current_map = map_id
	call_deferred("add_child", current_map)
	Global.current_map = current_map
	generate_world(current_map)

func _on_loaded_game():
	for i in get_children():
		i.queue_free()
	var current_map : Map = ResourceManager.get_map(world_data.current_map)
	call_deferred("add_child", current_map)
	Global.current_map = current_map
	generate_world(current_map)

func generate_world(current_map: Map):
	var current_map_info = ResourceManager.map_info[current_map.map_id]
	var current_world = []
	current_world.append(current_map.map_id)
	for map: Map in get_children():
		if map != current_map:
			if current_map_info.neighbor.find(map.map_id) == -1:
				map.queue_free()
			else:
				current_world.append(map.map_id)
	
	if current_map_info.has("up") and current_world.find(current_map_info.up) == -1:
		var map_up : Map = ResourceManager.get_map(current_map_info.up)
		map_up.global_position = current_map.global_position + Vector2(0, -896)
		call_deferred("add_child",map_up)
	if current_map_info.has("right_up") and current_world.find(current_map_info.right_up) == -1:
		var map_right_up : Map = ResourceManager.get_map(current_map_info.right_up)
		map_right_up.global_position = current_map.global_position + Vector2(896, -896)
		call_deferred("add_child",map_right_up)
	if current_map_info.has("right") and current_world.find(current_map_info.right) == -1:
		var map_right : Map = ResourceManager.get_map(current_map_info.right)
		map_right.global_position = current_map.global_position + Vector2(896, 0)
		call_deferred("add_child",map_right)
	if current_map_info.has("right_down") and current_world.find(current_map_info.right_down) == -1:
		var map_right_down : Map = ResourceManager.get_map(current_map_info.right_down)
		map_right_down.global_position = current_map.global_position + Vector2(896, 896)
		call_deferred("add_child",map_right_down)
	if current_map_info.has("down") and current_world.find(current_map_info.down) == -1:
		var map_down : Map = ResourceManager.get_map(current_map_info.down)
		map_down.global_position = current_map.global_position + Vector2(0, 896)
		call_deferred("add_child",map_down)
	if current_map_info.has("left_down") and current_world.find(current_map_info.left_down) == -1:
		var map_left_down : Map = ResourceManager.get_map(current_map_info.left_down)
		map_left_down.global_position = current_map.global_position + Vector2(-896, 896)
		call_deferred("add_child",map_left_down)
	if current_map_info.has("left") and current_world.find(current_map_info.left) == -1:
		var map_left : Map = ResourceManager.get_map(current_map_info.left)
		map_left.global_position = current_map.global_position + Vector2(-896, 0)
		call_deferred("add_child",map_left)
	if current_map_info.has("left_up") and current_world.find(current_map_info.left_up) == -1:
		var map_left_up : Map = ResourceManager.get_map(current_map_info.left_up)
		map_left_up.global_position = current_map.global_position + Vector2(-896, -896)
		call_deferred("add_child",map_left_up)
