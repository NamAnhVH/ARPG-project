extends Node

const STAT_PATH = "res://sources/scenes/items/stats.json"

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
	"stone": preload("res://assets/items/mace_v01.png")
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

