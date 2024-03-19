extends Resource
class_name PlayerData

@export var global_position : Vector2 
@export var inventory : Dictionary
@export var equipment : Dictionary
@export var health : int
@export var max_health : int = 10

var base_stats = {
	GameEnums.STAT.ATK: 5,
	GameEnums.STAT.MOVE_SPEED: 5,
	GameEnums.STAT.LIFE_POINT: 10
}

func set_data(data):
	global_position = data.global_position
	inventory = data.inventory
	equipment = data.equipment
	health = data.health
	max_health = data.max_health
	emit_changed()

func get_data():
	return {
		"global_position": global_position,
		"inventory": inventory,
		"equipment": equipment,
		"health": health,
		"max_health" : max_health
	}

func get_stat(stat):
	var stat_total = 0
	
	if base_stats.has(stat):
		stat_total += base_stats[stat]
	
	stat_total += InventoryManager.equipment.get_stat(stat)
	
	return int(round(stat_total))
