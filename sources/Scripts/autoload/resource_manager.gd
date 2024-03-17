extends Node

const STAT_PATH = "res://data/json/stats.json"

var sprites = {
	"sword_v00": preload("res://assets/items/sword_v00.png"),
	"sword_v01": preload("res://assets/items/sword_v01.png"),
	"sword_v02": preload("res://assets/items/sword_v02.png"),
	"sword_v03": preload("res://assets/items/sword_v03.png"),
	"sword_v04": preload("res://assets/items/sword_v04.png"),
	"axe_v00": preload("res://assets/items/axe_v00.png"),
	"axe_v01": preload("res://assets/items/axe_v01.png"),
	"axe_v02": preload("res://assets/items/axe_v02.png"),
	"axe_v03": preload("res://assets/items/axe_v03.png"),
	"axe_v04": preload("res://assets/items/axe_v04.png"),
	"mace_v00": preload("res://assets/items/mace_v00.png"),
	"mace_v01": preload("res://assets/items/mace_v01.png"),
	"mace_v02": preload("res://assets/items/mace_v02.png"),
	"mace_v03": preload("res://assets/items/mace_v03.png"),
	"mace_v04": preload("res://assets/items/mace_v04.png"),
	"ring_v00": preload("res://assets/items/ring_v00.png"),
	"stone": preload("res://assets/items/stone.png"),
	"coal": preload("res://assets/items/coal.png"),
	"iron": preload("res://assets/items/iron.png"),
	"copper": preload("res://assets/items/copper.png"),
	"silver": preload("res://assets/items/silver.png"),
	"gold": preload("res://assets/items/gold.png"),
	"healing_potion_v00": preload("res://assets/items/healing_potion_v00.png"),
	"healing_potion_v01": preload("res://assets/items/healing_potion_v01.png"),
	"healing_potion_v02": preload("res://assets/items/healing_potion_v02.png"),
	"healing_potion_v03": preload("res://assets/items/healing_potion_v03.png"),
	"healing_potion_v04": preload("res://assets/items/healing_potion_v04.png"),
}

var tscn = {
	"inventory_slot" : preload("res://sources/scenes/ui/inventory_slot.tscn"),
	"hotbar_slot": preload("res://sources/scenes/ui/hotbar_slot.tscn"),
	"floor_item": preload("res://sources/scenes/interactables/floor_item.tscn"),
	"cooldown": preload("res://sources/scenes/usable/cooldown.tscn"),
	"quantity": preload("res://sources/scenes/usable/quantity.tscn"),
	"inventory": preload("res://sources/scenes/ui/inventory.tscn"),
	"equipment": preload("res://sources/scenes/ui/equipment.tscn"),
	"chest": preload("res://sources/scenes/ui/chest.tscn")
}

var resources = {
	"game_data": preload("res://data/resources/game_data.tres"),
	"player_data": preload("res://data/resources/player_data.tres"),
	"setting_data": preload("res://data/resources/setting_data.tres")
}

var colors = {
	GameEnums.RARITY.COMMON : "000000",
	GameEnums.RARITY.UNCOMMON : "009623",
	GameEnums.RARITY.RARE : "0090FF",
	GameEnums.RARITY.EPIC : "9C00FF",
	GameEnums.RARITY.LEGENDARY : "FF0000",
}

var stat_info = {}

func _ready():
	var file = FileAccess.open(STAT_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	for stat in data:
		stat_info[GameEnums.STAT[stat]] = data[stat]
	file.close()


func set_font(font_size: int, color = "000000"):
	var label_setting = LabelSettings.new()
	label_setting.font = preload("res://font/m5x7.ttf")
	label_setting.font_size = font_size
	label_setting.font_color = Color(color)
	return label_setting

func get_instance(id):
	return tscn[id].instantiate()

