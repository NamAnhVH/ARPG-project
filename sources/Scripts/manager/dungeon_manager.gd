extends Node

var noise : FastNoiseLite
var slimes = []
var gremlins = []
var mushrooms = []

var path_atlas = [Vector2i(4,1), Vector2i(4,2), Vector2i(4,3), Vector2i(4,4)]

var source_id = 0

var broken_path_terrain = 0
var wall_ground_terrain = 0
var roof_terrain = 0

var ground_layer = 0
var floor_layer = 1
var roof_layer = 2

var special_map = {
	"dungeon_main": Vector2i.ZERO,
	"boss_gremlin": Vector2i(1, 0)
}

func _ready():
	SignalManager.generate_dungeon.connect(_on_generate_dungeon)

func _on_generate_dungeon():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.05
	for i in range(15):
		slimes.append(ResourceManager.get_character("slime"))
	for i in range(5):
		gremlins.append(ResourceManager.get_character("gremlin"))
	for i in range(10):
		mushrooms.append(ResourceManager.get_character("mushroom"))

