extends Map
class_name Dungeon

@export var map_size : Vector2i = Vector2i(30,30)

@onready var slimes = $Enemies/Slimes
@onready var gremlins = $Enemies/Gremlins
@onready var mushrooms = $Enemies/Mushrooms
@onready var navigation_region = $NavigationRegion2D
 
var border_up
var border_right
var border_down
var border_left

var tile_map : TileMap

var map_position : Vector2i = Vector2i.ZERO
var source_id = 0

var path_atlas = [Vector2i(4,1), Vector2i(4,2), Vector2i(4,3), Vector2i(4,4)]

var path_tiles = []

var broken_path_tiles = []
var broken_path_terrain = 0
var spawn_enemies = []

var wall_tiles = []
var wall_ground_terrain = 0

var roof_tiles = []
var roof_terrain = 0

var ground_layer = 0
var floor_layer = 1
var roof_layer = 2

var thread : Thread


func _ready():
	if map_id == "dungeon_main":
		border_up = 15
		border_left = 15
		border_right = 15
		border_down = 15
	else:
		tile_map = ResourceManager.get_instance("dungeon_map")
		generate_tiles()
		generate_enemy()
		map_id = str(map_position / 30)
		thread = Thread.new()
		thread.start(generate_map)

func generate_tiles():
	for x in range(map_position.x - 1, map_position.x + map_size.x + 1):
		for y in range(map_position.y - 1, map_position.y + map_size.y + 1):
			var noise_val = DungeonManager.noise.get_noise_2d(x, y)
			if noise_val >= 0.3:
				broken_path_tiles.append(Vector2i(x - map_position.x, y - map_position.y))
			elif noise_val >= -0.1:
				path_tiles.append(Vector2i(x - map_position.x, y - map_position.y))
			if noise_val < -0.1:
				wall_tiles.append(Vector2i(x - map_position.x, y - map_position.y))
				roof_tiles.append(Vector2i(x - map_position.x, y - map_position.y - 3))

func generate_map():
	for path in path_tiles:
		if !is_beside_wall(path):
			tile_map.set_cell(ground_layer, path, 0, path_atlas.pick_random())
		else:
			tile_map.set_cell(ground_layer, path, 0, Vector2i(4,0))
	tile_map.set_cells_terrain_connect(ground_layer, broken_path_tiles, 0, broken_path_terrain)
	tile_map.set_cells_terrain_connect(ground_layer, wall_tiles, 2, wall_ground_terrain)
	tile_map.set_cells_terrain_connect(roof_layer, roof_tiles, 1, roof_terrain)
	for x in range(-1, 30):
		if tile_map:
			tile_map.erase_cell(ground_layer, Vector2i(x, -3))
			tile_map.erase_cell(ground_layer, Vector2i(x, 30))
			tile_map.erase_cell(roof_layer, Vector2i(x, -1 - 3))
			tile_map.erase_cell(roof_layer, Vector2i(x, 30 - 3))
			tile_map.erase_cell(ground_layer, Vector2i(-1, x))
			tile_map.erase_cell(ground_layer, Vector2i(30, x))
			tile_map.erase_cell(roof_layer, Vector2i(-1, x - 3))
			tile_map.erase_cell(roof_layer, Vector2i(30, x - 3))
		
	call_deferred("generate_finish")

func generate_enemy():
	#spawn slime
	for i in randi_range(1, 4):
		var enemy = DungeonManager.slimes.pop_front()
		if enemy != null:
			var average_level = (abs(map_position.x / 30) + abs(map_position.y / 30)) * 2
			enemy.min_level = clamp(average_level - 2, 1, average_level)
			enemy.max_level = average_level + 2
			enemy.global_position = broken_path_tiles.pick_random() * 16
			slimes.call_deferred("add_child", enemy)
	#spawn gremlin
	for i in randi_range(0, 3):
		if i:
			var enemy = DungeonManager.gremlins.pop_front()
			if enemy:
				var average_level = (abs(map_position.x / 30) + abs(map_position.y / 30)) * 2
				enemy.min_level = clamp(average_level - 2, 1, average_level)
				enemy.max_level = average_level + 2
				enemy.global_position = broken_path_tiles.pick_random() * 16
				gremlins.call_deferred("add_child", enemy)
	#Spawn mushroom
	for i in randi_range(0, 4):
		if i:
			var enemy = DungeonManager.mushrooms.pop_front()
			if enemy:
				var average_level = (abs(map_position.x / 30) + abs(map_position.y / 30)) * 2
				enemy.min_level = clamp(average_level - 2, 1, average_level)
				enemy.max_level = average_level + 2
				enemy.global_position = broken_path_tiles.pick_random() * 16
				mushrooms.call_deferred("add_child", enemy) 
	
func generate_finish():
	thread.wait_to_finish()
	add_child(tile_map)

func is_beside_wall(tile):
	return wall_tiles.find(tile + Vector2i(0, -1)) != -1 \
	or wall_tiles.find(tile + Vector2i(1, -1)) != -1 \
	or wall_tiles.find(tile + Vector2i(1, 0)) != -1 \
	or wall_tiles.find(tile + Vector2i(1, 1)) != -1 \
	or wall_tiles.find(tile + Vector2i(0, 1)) != -1 \
	or wall_tiles.find(tile + Vector2i(-1, 1)) != -1 \
	or wall_tiles.find(tile + Vector2i(-1, 0)) != -1 \
	or wall_tiles.find(tile + Vector2i(-1, -1)) != -1

func remove_enemy():
	for enemy_type in enemies.get_children():
		if enemy_type:
			for enemy in enemy_type.get_children():
				enemy_type.remove_child(enemy)
				if enemy is SlimeCharacter:
					DungeonManager.slimes.append(enemy)
				elif enemy is GremlinCharacter:
					DungeonManager.gremlins.append(enemy)
				elif enemy is MushroomCharacter:
					DungeonManager.mushrooms.append(enemy)
