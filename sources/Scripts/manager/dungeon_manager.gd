extends Node

var noise : FastNoiseLite
var slimes = []
var gremlins = []

var wall_atlas = [
	Vector2i(8, 10), Vector2i(8, 9), Vector2i(8, 8), Vector2i(8, 7), Vector2i(8, 6),
	Vector2i(10, 1), 
	Vector2i(24, 16), Vector2i(24, 15), Vector2i(24, 14), Vector2i(24, 13), Vector2i(24, 12), Vector2i(24, 11),
	Vector2i(22, 15), Vector2i(22, 14), Vector2i(22, 13), Vector2i(22, 12), Vector2i(22, 11), Vector2i(22, 10),
	Vector2i(30, 16), Vector2i(30, 15), Vector2i(30, 14), Vector2i(30, 13), Vector2i(30, 12), Vector2i(30, 11),
	Vector2i(32, 15), Vector2i(32, 14), Vector2i(32, 13), Vector2i(32, 12), Vector2i(32, 11), Vector2i(32, 10), 
	Vector2i(25, 11), Vector2i(25, 12),
	Vector2i(28, 1),
	Vector2i(29, 11), Vector2i(29, 12)]

func _ready():
	noise = FastNoiseLite.new()
	noise.frequency = 0.05
	for i in range(500):
		slimes.append(ResourceManager.get_character("slime"))
	for i in range(100):
		gremlins.append(ResourceManager.get_character("gremlin"))

