extends Node

const ITEM_PATH : String = "res://sources/data/items.json"
const AFFIXES_PATH : String = "res://sources/data/affixes.json"
const RARE_NAMES_PATH : String = "res://sources/data/rare_names.json"

var items = {}
var rare_names = {}
var affix_groups = {}

@onready var placeholders = {
	GameEnums.EQUIPMENT_TYPE.HEAD : preload("res://assets/placeholders/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST : preload("res://assets/placeholders/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.PANTS : preload("res://assets/placeholders/placeholder_pants.png"),
	GameEnums.EQUIPMENT_TYPE.SHOES : preload("res://assets/placeholders/placeholder_shoes.png"),
	GameEnums.EQUIPMENT_TYPE.ONE_HAND_WEAPON : preload("res://assets/placeholders/placeholder_one_hand_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.SHIELD : preload("res://assets/placeholders/placeholder_shield.png"),
	GameEnums.EQUIPMENT_TYPE.ACCESSORY : preload("res://assets/placeholders/placeholder_accessory.png"),
	GameEnums.EQUIPMENT_TYPE.BOW : preload("res://assets/placeholders/placeholder_bow.png"),
	GameEnums.EQUIPMENT_TYPE.SPEAR : preload("res://assets/placeholders/placeholder_spear.png")
}

func _init():
	randomize()

func _ready():
	#Item
	var item_file = FileAccess.open(ITEM_PATH, FileAccess.READ)
	items = JSON.parse_string(item_file.get_as_text())
	item_file.close()
	
	#Item
	var affix_file = FileAccess.open(AFFIXES_PATH, FileAccess.READ)
	var data = JSON.parse_string(affix_file.get_as_text())
	affix_file.close()
	for id in data:
		affix_groups[id] = AffixGroup.new(id, data[id])
	
	#Rare Name
	var rare_name_file = FileAccess.open(RARE_NAMES_PATH, FileAccess.READ)
	rare_names = JSON.parse_string(rare_name_file.get_as_text())
	item_file.close()

func get_item(id: String):
	return Item.new(id, items[id])

func get_placeholder(id):
	return placeholders[id]

func rng_generate_rarity(ilevel) -> Item:
	var valid_items_key = []
	for i in items:
		if items[i].has("type") and ilevel >= items[i].level:
			valid_items_key.append(i)
	valid_items_key.shuffle()
	var item = get_item(valid_items_key[0])
	return generate_rarity(item, ilevel)

func generate_rarity(item: Item, ilevel):
	item.components.base_stats.scale = randf()
	
	var number_of_affixes = 0
	var rng = randf()
	
	if rng >= 0.99 and item.legendary_data:
		item.rarity = GameEnums.RARITY.LEGENDARY
		generate_legendary(item)
		return item
	elif rng >= 0.95:
		item.rarity = GameEnums.RARITY.EPIC
		number_of_affixes = 3
		set_rare_name(item)
	elif rng >= 0.85:
		item.rarity = GameEnums.RARITY.RARE
		number_of_affixes = 2
		set_rare_name(item)
	elif rng >= 0.60:
		item.rarity = GameEnums.RARITY.UNCOMMON
		number_of_affixes = 1
	else:
		return item
	
	var random_affix_groups = get_random_affix_group(number_of_affixes, item.equipment_type, ilevel)
	var item_affix_list_data = []
	
	for affix_group in random_affix_groups:
		if affix_group:
			var data = {
				"affix_groups": affix_group.id,
				"affix": affix_group.get_random_affix(ilevel),
				"scale": randf()
			}
			item_affix_list_data.append(data)
	
	item.components["affix_list"] = AffixItemList.new(item_affix_list_data, item.rarity)
	return item

func get_random_affix_group(number_of_affixes, item_type, ilevel):
	var valid_prefix = get_valid_affixes_group(GameEnums.AFFIX_TYPE.PREFIX, item_type, ilevel)
	var valid_suffix = get_valid_affixes_group(GameEnums.AFFIX_TYPE.SUFFIX, item_type, ilevel)
	
	valid_prefix.shuffle()
	valid_suffix.shuffle()
	
	var prefix_amount = int(floor(number_of_affixes / 2.0))
	var suffix_amount = prefix_amount
	
	if number_of_affixes % 2 == 1:
		if randi() % 2 == 1:
			prefix_amount += 1
		else:
			suffix_amount += 1
	
	valid_prefix.resize(prefix_amount)
	valid_suffix.resize(suffix_amount)
	
	var valid_affixes : Array[AffixGroup] = []
	valid_affixes.append_array(valid_prefix)
	valid_affixes.append_array(valid_suffix)
	return valid_affixes

func get_valid_affixes_group(affix_type, item_type, ilevel):
	var valid_affixes : Array[AffixGroup] = []
	
	for id in affix_groups:
		if affix_groups[id].type == affix_type and ilevel >= affix_groups[id].affixes.values()[0].min_level and affix_groups[id].apply_to.has(item_type):
			valid_affixes.append(affix_groups[id])
	return valid_affixes

func set_rare_name(item: Item):
	var type = GameEnums.EQUIPMENT_TYPE.keys()[item.equipment_type]
	var name_prefix_type = rare_names.prefix[type]
	var name_prefix = name_prefix_type[randi() % name_prefix_type.size()]
	var name_suffix_type = rare_names.suffix[type]
	var name_suffix = name_suffix_type[randi() % name_suffix_type.size()]
	item.item_name = name_prefix + " " + name_suffix

func generate_legendary(item: Item):
	var scales = []
	for s in item.legendary_data.stats:
		scales.append(randf())
	
	item.item_name = item.legendary_data.name
	item.components["legendary_stats"] = ItemLegendaryStats.new(item.legendary_data.stats, scales)
