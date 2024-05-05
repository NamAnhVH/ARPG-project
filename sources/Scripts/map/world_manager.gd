extends Node2D
class_name WorldManager

const DUNGEON_SIZE : int = 30

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

func _on_change_map(map: Map):
	if map is Dungeon:
		pass
	else:
		world_data.current_map = map.map_id
		Global.current_map = map
	generate_world(map)

func _on_change_world(map_id, location, player_z_index):
	SignalManager.clear_hidden_node.emit()
	SignalManager.inventory_closed.emit()
	for map in get_children():
		map.free()
	var current_map = ResourceManager.get_map(map_id)
	world_data.current_map = map_id
	player_data.global_position = location
	player_data.z_index = player_z_index
	Global.current_map = current_map
	call_deferred("add_child", current_map)
	generate_world(current_map)

func _on_loaded_game():
	for i in get_children():
		i.queue_free()
	var current_map : Map = ResourceManager.get_map(world_data.current_map)
	call_deferred("add_child", current_map)
	Global.current_map = current_map
	generate_world(current_map)

func generate_world(current_map: Map):
	if current_map is Dungeon:
		var current_world = []
		var current_map_position = format_map_id_to_vector(current_map.map_id)
		for map: Dungeon in get_children():
			if map != current_map:
				var map_position = format_map_id_to_vector(map.map_id)
				if abs(map_position.x - current_map_position.x) >= 2 \
				or abs(map_position.y - current_map_position.y) >= 2:
					map.queue_free()
				else:
					current_world.append(map_position)
		
		if current_world.find(current_map_position + Vector2i(0, -1)) == -1:
			var map_up : Dungeon = ResourceManager.get_map("dungeon")
			map_up.map_position = (current_map_position + Vector2i(0, -1)) * DUNGEON_SIZE
			map_up.global_position = map_up.map_position * 16
			map_up.map_down = current_map
			current_map.map_up = map_up
			call_deferred("add_child", map_up)
			
		if current_world.find(current_map_position + Vector2i(1, 0)) == -1:
			var map_right : Dungeon = ResourceManager.get_map("dungeon")
			map_right.map_position = (current_map_position + Vector2i(1, 0)) * DUNGEON_SIZE
			map_right.global_position = map_right.map_position * 16
			map_right.map_left = current_map
			current_map.map_right = map_right
			call_deferred("add_child",map_right)
		
		if current_world.find(current_map_position + Vector2i(0, 1)) == -1:
			var map_down : Dungeon = ResourceManager.get_map("dungeon")
			map_down.map_position = (current_map_position + Vector2i(0, 1)) * DUNGEON_SIZE
			map_down.global_position = map_down.map_position * 16
			map_down.map_up = current_map
			current_map.map_down = map_down
			call_deferred("add_child", map_down)
		
		if current_world.find(current_map_position + Vector2i(-1, 0)) == -1:
			var map_left : Dungeon = ResourceManager.get_map("dungeon")
			map_left.map_position = (current_map_position + Vector2i(-1, 0)) * DUNGEON_SIZE
			map_left.global_position = map_left.map_position * 16
			map_left.map_right = current_map
			current_map.map_left = map_left
			call_deferred("add_child", map_left)
			
		if current_world.find(current_map_position + Vector2i(1, -1)) == -1:
			var map_right_up : Dungeon = ResourceManager.get_map("dungeon")
			map_right_up.map_position = (current_map_position + Vector2i(1, -1)) * DUNGEON_SIZE
			map_right_up.global_position = map_right_up.map_position * 16
			map_right_up.map_left = current_map.map_up
			current_map.map_up.map_right = map_right_up
			map_right_up.map_down = current_map.map_right
			current_map.map_right.map_up = map_right_up
			call_deferred("add_child", map_right_up)
			
		if current_world.find(current_map_position + Vector2i(1, 1)) == -1:
			var map_right_down : Dungeon = ResourceManager.get_map("dungeon")
			map_right_down.map_position = (current_map_position + Vector2i(1, 1)) * DUNGEON_SIZE
			map_right_down.global_position = map_right_down.map_position * 16
			map_right_down.map_up = current_map.map_right
			current_map.map_right.map_down = map_right_down
			map_right_down.map_left = current_map.map_down
			current_map.map_down.map_right = map_right_down
			call_deferred("add_child", map_right_down)
			
		if current_world.find(current_map_position + Vector2i(-1, 1)) == -1:
			var map_left_down : Dungeon = ResourceManager.get_map("dungeon")
			map_left_down.map_position = (current_map_position + Vector2i(-1, 1)) * DUNGEON_SIZE
			map_left_down.global_position = map_left_down.map_position * 16
			map_left_down.map_right = current_map.map_down
			current_map.map_left.map_down = map_left_down
			map_left_down.map_up = current_map.map_left
			current_map.map_down.map_left = map_left_down
			call_deferred("add_child", map_left_down)
			
		if current_world.find(current_map_position + Vector2i(-1, -1)) == -1:
			var map_left_up : Dungeon = ResourceManager.get_map("dungeon")
			map_left_up.map_position = (current_map_position + Vector2i(-1, -1)) * DUNGEON_SIZE
			map_left_up.global_position = map_left_up.map_position * 16
			map_left_up.map_down = current_map.map_left
			current_map.map_left.map_up = map_left_up
			map_left_up.map_right = current_map.map_up
			current_map.map_up.map_left = map_left_up
			call_deferred("add_child", map_left_up)
	else:
		var current_map_info = ResourceManager.map_info[current_map.map_id]
		var current_world = []
		current_world.append(current_map.map_id)
		for map: Map in get_children():
			if map != current_map:
				if current_map_info.has("neighbor") and current_map_info.neighbor.find(map.map_id) == -1:
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

func format_map_id_to_vector(map_id) -> Vector2i:
	if map_id and map_id != "dungeon_main":
		var values = map_id.replace("(", "").replace(")", "").split(",")
		var vector = Vector2i(int(values[0]), int(values[1]))
		return vector
	else:
		return Vector2i.ZERO
