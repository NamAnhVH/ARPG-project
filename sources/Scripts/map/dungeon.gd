extends Map
class_name Dungeon

@export var map_size : Vector2i = Vector2i(30,30)

@onready var slimes = $Enemies/Slimes
@onready var gremlins = $Enemies/Gremlins
@onready var navigation_region = $NavigationRegion2D
 
var border_up
var border_right
var border_down
var border_left
var borders = []

var map_up
var map_right
var map_down
var map_left

var tile_map : TileMap

var map_position : Vector2i = Vector2i.ZERO
var source_id = 0

var path_atlas = [Vector2i(4,1), Vector2i(4,2), Vector2i(4,3), Vector2i(4,4)]

var path_tiles = []

var broken_path_tiles = []
var broken_path_terrain = 0
var spawn_enemies = []

var hole_tiles = []
var hole_terrain = 0

var ground_layer = 0
var floor_layer = 1
var hole_layer = 2

var thread : Thread


func _ready():
	if map_id == "dungeon_main":
		border_up = 15
		border_left = 15
		border_right = 15
		border_down = 15
	else:
		map_id = str(map_position / 30)
		tile_map = ResourceManager.get_instance("dungeon_map")
		generate_tiles()
		#generate_enemy()
		thread = Thread.new()
		thread.start(generate_map)

func generate_tiles():
	pass
	##Ver_2
	generate_path()
	var duplicate_borders = borders.duplicate()
	while !duplicate_borders.is_empty():
		var start = duplicate_borders.pop_front()
		var end = duplicate_borders.pop_front()
		
		if abs(start.x - end.x) >= 9:
			if start.x > end.x:
				var temp = start
				start = end
				end = temp
			var x = start.x
			while x < end.x:
				var slope = (end.y - start.y) * 1.0 / (end.x - start.x)
				var intercept = start.y - slope * start.x
				var y = roundi(slope * x + intercept)
				for i in range(x - 5, x + 5):
					for j in range(y - 5, y + 5):
						var tile_position = Vector2i(i, j)
						if path_tiles.find(tile_position) == -1 \
						and tile_position.x < 30 and tile_position.x >= 0 \
						and tile_position.y < 30 and tile_position.y >= 0:
							path_tiles.append(tile_position)
				x += 3
			for i in range(end.x - 5, end.x + 5):
				for j in range(end.y - 5, end.y + 5):
					var tile_position = Vector2i(i, j)
					if path_tiles.find(tile_position) == -1 \
					and tile_position.x < 30 and tile_position.x >= 0 \
					and tile_position.y < 30 and tile_position.y >= 0:
						path_tiles.append(tile_position)
		else:
			if start.y > end.y:
				var temp = start
				start = end
				end = temp
			var y = start.y
			while y < end.y:
				var slope = (end.y - start.y) * 1.0 / (end.x - start.x)
				var intercept = start.y - slope * start.x
				var x = roundi((y - intercept) / slope)
				for i in range(x - 5, x + 5):
					for j in range(y - 5, y + 5):
						var tile_position = Vector2i(i, j)
						if path_tiles.find(tile_position) == -1 \
						and tile_position.x < 30 and tile_position.x >= 0 \
						and tile_position.y < 30 and tile_position.y >= 0:
							path_tiles.append(tile_position)
				y += 3
			for i in range(end.x - 5, end.x + 5):
				for j in range(end.y - 5, end.y + 5):
					var tile_position = Vector2i(i, j)
					if path_tiles.find(tile_position) == -1 \
					and tile_position.x < 30 and tile_position.x >= 0 \
					and tile_position.y < 30 and tile_position.y >= 0:
						path_tiles.append(tile_position)
		
	for i in range(-1, 31):
		for j in range(-1, 31):
			if path_tiles.find(Vector2i(i, j)) == -1:
				hole_tiles.append(Vector2i(i, j))
	##Ver_1
	#for x in range(map_position.x - 1, map_position.x + map_size.x + 1):
		#for y in range(map_position.y - 1, map_position.y + map_size.y + 1):
			#var noise_val = DungeonManager.noise.get_noise_2d(x, y)
			#if noise_val >= 0.3:
				#broken_path_tiles.append(Vector2i(x - map_position.x, y - map_position.y))
			#elif noise_val >= -0.1:
				#path_tiles.append(Vector2i(x - map_position.x, y - map_position.y))
			#if noise_val < -0.1:
				#hole_tiles.append(Vector2i(x - map_position.x, y - map_position.y))

func generate_map():
	for path in path_tiles:
		if !is_beside_hole(path):
			tile_map.set_cell(ground_layer, path, 0, path_atlas.pick_random())
		else:
			tile_map.set_cell(ground_layer, path, 0, Vector2i(4,0))
	tile_map.set_cells_terrain_connect(ground_layer, broken_path_tiles, 0, broken_path_terrain)
	tile_map.set_cells_terrain_connect(hole_layer, hole_tiles, 1, hole_terrain)
	for x in range(-1, 30):
		if tile_map:
			tile_map.erase_cell(ground_layer, Vector2i(x, -1))
			tile_map.erase_cell(ground_layer, Vector2i(x, 30))
			tile_map.erase_cell(hole_layer, Vector2i(x, -1))
			tile_map.erase_cell(hole_layer, Vector2i(x, 30))
			tile_map.erase_cell(ground_layer, Vector2i(-1, x))
			tile_map.erase_cell(ground_layer, Vector2i(30, x))
			tile_map.erase_cell(hole_layer, Vector2i(-1, x))
			tile_map.erase_cell(hole_layer, Vector2i(30, x))
		
	call_deferred("generate_finish")

func generate_enemy():
	#spawn slime
	for i in randi_range(1, 5):
		var enemy = DungeonManager.slimes.pop_front()
		if enemy:
			enemy.global_position = broken_path_tiles.pick_random() * 16
			enemy.texture = preload("res://assets/monsters/slimes/slime_v01.png")
			slimes.call_deferred("add_child", enemy)
	#spawn gremlin
	for i in randi_range(0, 3):
		if i:
			var enemy = DungeonManager.gremlins.pop_front()
			if enemy:
				enemy.global_position = broken_path_tiles.pick_random() * 16
				enemy.texture = preload("res://assets/monsters/gremlins/gremlin_v00.png")
				gremlins.call_deferred("add_child", enemy)

func generate_finish():
	thread.wait_to_finish()
	add_child(tile_map)
	#navigation_region.add_child(tile_map)
	#var new_navigation_mesh = NavigationPolygon.new()
	#var new_vertices = PackedVector2Array([Vector2(0, 0), Vector2(0, 480), Vector2(480, 480), Vector2(480, 0)])
	#new_navigation_mesh.vertices = new_vertices
	#var new_polygon_indices = PackedInt32Array([0, 1, 2, 3])
	#new_navigation_mesh.add_polygon(new_polygon_indices)
	#navigation_region.navigation_polygon = new_navigation_mesh

func is_beside_hole(tile):
	return hole_tiles.find(tile + Vector2i(0, -1)) != -1 \
	or hole_tiles.find(tile + Vector2i(1, -1)) != -1 \
	or hole_tiles.find(tile + Vector2i(1, 0)) != -1 \
	or hole_tiles.find(tile + Vector2i(1, 1)) != -1 \
	or hole_tiles.find(tile + Vector2i(0, 1)) != -1 \
	or hole_tiles.find(tile + Vector2i(-1, 1)) != -1 \
	or hole_tiles.find(tile + Vector2i(-1, 0)) != -1 \
	or hole_tiles.find(tile + Vector2i(-1, -1)) != -1

func generate_path():
	if map_up and map_up.border_down:
		border_up = map_up.border_down
		borders.append(Vector2i(border_up, 0))
	if map_right and map_right.border_left:
		border_right = map_right.border_left
		borders.append(Vector2i(map_size.x, border_right))
	if map_down and map_down.border_up:
		border_down = map_down.border_up
		borders.append(Vector2i(border_down, map_size.y))
	if map_left and map_left.border_right:
		border_left = map_left.border_right
		borders.append(Vector2i(0, border_left))
	var border_max = 0
	if !map_up or map_up.border_down or map_up.borders.size() == 0:
		border_max += 1
	if !map_right or map_right.border_left or map_right.borders.size() == 0:
		border_max += 1
	if !map_down or map_down.border_up or map_down.borders.size() == 0:
		border_max += 1 
	if !map_left or map_left.border_right or map_left.borders.size() == 0:
		border_max += 1
	var borders_size = randi_range(1, border_max / 2)
	while borders.is_empty() or borders.size() < borders_size * 2:
		var rand_border = randi_range(1, 4)
		match rand_border:
			1:
				if (!map_up or map_up.borders.size() == 0) and !border_up:
					border_up = randi_range(10, 20)
					borders.append(Vector2i(border_up, 0))
			2:
				if (!map_right or map_right.borders.size() == 0) and !border_right:
					border_right = randi_range(10, 20)
					borders.append(Vector2i(map_size.x, border_right))
			3:
				if (!map_down or map_down.borders.size() == 0) and !border_down:
					border_down = randi_range(10, 20)
					borders.append(Vector2i(border_down, map_size.y))
			4:
				if (!map_left or map_left.borders.size() == 0) and !border_left:
					border_left = randi_range(10, 20)
					borders.append(Vector2i(0, border_left))
	
	borders.shuffle()
