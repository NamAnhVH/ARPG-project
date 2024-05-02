extends Node

const ITEM_PATH : String = "res://data/json/items.json"
const AFFIXES_PATH : String = "res://data/json/affixes.json"

@onready var placeholders = {
	GameEnums.EQUIPMENT_TYPE.HELMET : preload("res://assets/placeholders/placeholder_helmet.png"),
	GameEnums.EQUIPMENT_TYPE.ARMOR : preload("res://assets/placeholders/placeholder_armor.png"),
	GameEnums.EQUIPMENT_TYPE.PANTS : preload("res://assets/placeholders/placeholder_pants.png"),
	GameEnums.EQUIPMENT_TYPE.SHOES : preload("res://assets/placeholders/placeholder_shoes.png"),
	GameEnums.EQUIPMENT_TYPE.WEAPON : preload("res://assets/placeholders/placeholder_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON : preload("res://assets/placeholders/placeholder_extra_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.ACCESSORY : preload("res://assets/placeholders/placeholder_accessory.png"),
}

var equipment_names = {
	GameEnums.EQUIPMENT_TYPE.HELMET: "Helmet",
	GameEnums.EQUIPMENT_TYPE.ARMOR: "Armor",
	GameEnums.EQUIPMENT_TYPE.PANTS: "Pants",
	GameEnums.EQUIPMENT_TYPE.SHOES: "Shoes",
	GameEnums.EQUIPMENT_TYPE.WEAPON: "Weapon",
	GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON: "Extra weapon",
	GameEnums.EQUIPMENT_TYPE.ACCESSORY: "Accessory"
}

var type_names = {
	GameEnums.ITEM_TYPE.CONSUMABLE: "Consumable",
	GameEnums.ITEM_TYPE.MATERIAL: "Material",
	GameEnums.ITEM_TYPE.EQUIPMENT: "Equipment"
}

var items = {}
var rare_names = {}
var affixes = []
var usable = {
	"healing": preload("res://sources/scripts/usable/healing.gd"),
	"buff": preload("res://sources/scripts/usable/buff.gd")
}

func _init():
	randomize()

func _ready():
	#Item
	var item_file = FileAccess.open(ITEM_PATH, FileAccess.READ)
	items = JSON.parse_string(item_file.get_as_text())
	item_file.close()
	
	#Affix
	var affix_file = FileAccess.open(AFFIXES_PATH, FileAccess.READ)
	affixes = JSON.parse_string(affix_file.get_as_text())
	affix_file.close()

func get_item(id: String):
	return Item.new(id, items[id])

func get_items(items_data : Array):
	var items_array = []
	for item_data in items_data:
		items_array.append(get_item_from_data(item_data))
	return items_array

func get_item_from_data(item_data):
	var item = get_item(item_data.id)
	item.quantity = item_data.quantity
	if item_data.has("item_name"):
		item.item_name = item_data.item_name
	if item_data.has("rarity"):
		item.rarity = item_data.rarity
	if item_data.has("components"):
		if item_data.components.has("base_stats"):
			item.components.base_stats = BaseStat.new(item_data.components.base_stats, item.rarity)
	return item

func get_item_name(id: String):
	return items[id].name

func get_placeholder(id):
	return placeholders[id]

func rng_generate_rarity(ilevel) -> Item:
	var valid_items_key = []
	for i in items:
		if items[i].has("type") and ilevel >= items[i].level and GameEnums.ITEM_TYPE[items[i].type] == GameEnums.ITEM_TYPE.EQUIPMENT:
			valid_items_key.append(i)
	valid_items_key.shuffle()
	var item = get_item(valid_items_key[randi() % valid_items_key.size()])
	return generate_random_rarity(item, ilevel)

func generate_random_rarity(item, ilevel):
	var rarity = GameEnums.RARITY.COMMON
	var rng = randf()
	if rng > 0.999 and item.legendary_data:
		rarity = GameEnums.RARITY.LEGENDARY
	elif rng >= 0.98:
		rarity = GameEnums.RARITY.DIVINE
	elif rng >= 0.95:
		rarity = GameEnums.RARITY.EPIC 
	elif rng >= 0.90:
		rarity = GameEnums.RARITY.UNIQUE
	elif rng >= 0.85:
		rarity = GameEnums.RARITY.RARE
	elif rng >= 0.60:
		rarity = GameEnums.RARITY.UNCOMMON
	
	generate_rarity(item, ilevel, rarity)
	return item

func generate_rarity(item: Item, ilevel, rarity):
	item.rarity = rarity
	var number_of_affixes = 0
	
	if rarity == GameEnums.RARITY.LEGENDARY:
		item.rarity = GameEnums.RARITY.LEGENDARY
		generate_legendary(item)
		return item
	elif rarity == GameEnums.RARITY.DIVINE:
		item.rarity = GameEnums.RARITY.DIVINE
		number_of_affixes = 5
	elif rarity == GameEnums.RARITY.EPIC:
		item.rarity = GameEnums.RARITY.EPIC
		number_of_affixes = 4
	elif rarity == GameEnums.RARITY.UNIQUE:
		item.rarity = GameEnums.RARITY.UNIQUE
		number_of_affixes = 3
	elif rarity == GameEnums.RARITY.RARE:
		item.rarity = GameEnums.RARITY.RARE
		number_of_affixes = 2
	elif rarity == GameEnums.RARITY.UNCOMMON:
		item.rarity = GameEnums.RARITY.UNCOMMON
		number_of_affixes = 1
	else:
		return item
	
	var random_affix_groups = get_random_affix_group(number_of_affixes, ilevel)
	item.components["base_stats"].add_affixes(random_affix_groups, item.rarity)
	return item

func get_random_affix_group(number_of_affixes, ilevel):
	var valid_affixes = []
	while valid_affixes.size() < number_of_affixes:
		var affix = get_affix_stat(affixes.pick_random(), ilevel)
		valid_affixes.append(affix)
	return valid_affixes

func get_affix_stat(affix, ilevel):
	var value = 0
	for affix_level in affix.affixes:
		if ilevel >= affix_level.min_level:
			value = randi_range(1, affix_level.maximum)
	return {
		"stat": affix.stat,
		"value": value
	}

func generate_legendary(item: Item):
	item.item_name = item.legendary_data.name
	item.components["base_stats"] = BaseStat.new(item.legendary_data.stats, GameEnums.RARITY.LEGENDARY)
	if item.legendary_data.has("usable"):
		set_usable(item, item.legendary_data)

func get_usable(data_usable, item):
	return usable[data_usable.type.split("_")[0]].new(data_usable.data, item, data_usable.type)

func set_usable(item: Item, data):
	item.components["usable"] = get_usable(data.usable, item)

func get_type_name(item: Item):
	if item.type == GameEnums.ITEM_TYPE.EQUIPMENT:
		return equipment_names[item.equipment_type]
	else:
		return type_names[item.type]

func get_type_name_with_id(id: String):
	if GameEnums.ITEM_TYPE[items[id].type] == GameEnums.ITEM_TYPE.EQUIPMENT:
		return equipment_names[GameEnums.EQUIPMENT_TYPE[items[id].equipment_type]]
	else:
		return type_names[GameEnums.ITEM_TYPE[items[id].type]]

func can_stack(id: String, quantity):
	if items[id].has("stack_size"):
		if quantity <= items[id].stack_size:
			return true
	return false
	
