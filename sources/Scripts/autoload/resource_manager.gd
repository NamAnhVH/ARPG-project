extends Node

const STAT_PATH = "res://sources/data/stats.json"

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
	"stone": preload("res://assets/items/stone.png"),
	"coal": preload("res://assets/items/coal.png"),
	"iron": preload("res://assets/items/iron.png"),
	"copper": preload("res://assets/items/copper.png"),
	"silver": preload("res://assets/items/silver.png"),
	"gold": preload("res://assets/items/gold.png")
}

var tscn = {
	"inventory_slot" : preload("res://sources/scenes/ui/inventory_slot.tscn"),
	"hotbar_slot": preload("res://sources/scenes/ui/hotbar_slot.tscn"),
	"floor_item": preload("res://sources/scenes/interactables/floor_item.tscn")
}

var colors = {
	GameEnums.RARITY.COMMON : "B9B9B8",
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

