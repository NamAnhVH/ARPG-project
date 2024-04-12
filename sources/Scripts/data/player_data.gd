extends Resource
class_name PlayerData

@export var global_position : Vector2 
@export var inventory : Dictionary
@export var equipment : Dictionary
@export var health : int
@export var max_health : int
@export var money : int
@export var z_index : int
@export var experience : int = 0
@export var level : int = 1
@export var player_name : String

var base_stats = {
	GameEnums.STAT.ATK: 5,
	GameEnums.STAT.MOVE_SPEED: 0,
	GameEnums.STAT.LIFE_POINT: 10
}

func set_data(data):
	global_position = data.global_position
	inventory = data.inventory
	equipment = data.equipment
	player_name = data.player_name if data.has("player_name") else ""
	Global.player_name = player_name
	health = data.health if data.has("health") and data.health != 0 else 10
	max_health = data.max_health if data.has("max_health") and data.max_health != 0 else 10
	money = data.money if data.has("money") else 0 
	z_index = data.z_index if data.has("z_index") and data.z_index != 0 else 1
	level = data.level if data.has("level") and level != 0 else 1
	experience = data.experience if data.has("experience") else 0
	emit_changed()

func get_data():
	return {
		"global_position": global_position,
		"inventory": inventory,
		"equipment": equipment,
		"player_name": player_name,
		"health": health,
		"max_health" : max_health,
		"money": money,
		"z_index": z_index,
		"level": level,
		"experience": experience
	}

func get_stat(stat):
	var stat_total = 0
	
	if base_stats.has(stat):
		stat_total += base_stats[stat]
	
	stat_total += InventoryManager.equipment.get_stat(stat)
	
	return int(round(stat_total))


	
