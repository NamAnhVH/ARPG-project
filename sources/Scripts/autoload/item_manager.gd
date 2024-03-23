extends Node

const ITEM_PATH : String = "res://data/json/items.json"
const AFFIXES_PATH : String = "res://data/json/affixes.json"
const RARE_NAMES_PATH : String = "res://data/json/rare_names.json"

@onready var placeholders = {
	GameEnums.EQUIPMENT_TYPE.HEAD : preload("res://assets/placeholders/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST : preload("res://assets/placeholders/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.PANTS : preload("res://assets/placeholders/placeholder_pants.png"),
	GameEnums.EQUIPMENT_TYPE.SHOES : preload("res://assets/placeholders/placeholder_shoes.png"),
	GameEnums.EQUIPMENT_TYPE.WEAPON : preload("res://assets/placeholders/placeholder_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON : preload("res://assets/placeholders/placeholder_extra_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.ACCESSORY : preload("res://assets/placeholders/placeholder_accessory.png"),
}

var equipment_names = {
	GameEnums.EQUIPMENT_TYPE.HEAD: "Head",
	GameEnums.EQUIPMENT_TYPE.CHEST: "Chest",
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
var affix_groups = {}
var usable = {
	"healing": preload("res://sources/scripts/usable/item_healing.gd")
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
	rare_name_file.close()

func get_item(id: String):
	return Item.new(id, items[id])

func get_items( items_data : Array ):
	var items_array = []
	for item_data in items_data:
		items_array.append( get_item_from_data( item_data ) )
	return items_array

func get_item_from_data( item_data ):
	var item = get_item( item_data.id )
	item.quantity = item_data.quantity
	if item_data.has("item_name"):
		item.item_name = item_data.item_name
	if item_data.has("rarity"):
		item.rarity = item_data.rarity
	if item_data.has("components"):
		if item_data.components.has("base_stats"):
			item.components.base_stats.scale = item_data.components.base_stats
		if item_data.components.has("affix_list"):
			item.components.affix_list = AffixItemList.new(item_data.components.affix_list, item_data.rarity)
		if item_data.components.has("legendary_stats"):
			set_legendary(item, item_data.components.legendary_stats)
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
	item.components.base_stats.scale = randf()
	
	var rarity = GameEnums.RARITY.COMMON
	var rng = randf()
	if rng >= 0.99 and item.legendary_data:
		item.rarity = GameEnums.RARITY.LEGENDARY
	elif rng >= 0.95:
		item.rarity = GameEnums.RARITY.EPIC
	elif rng >= 0.85:
		item.rarity = GameEnums.RARITY.RARE
	elif rng >= 0.60:
		item.rarity = GameEnums.RARITY.UNCOMMON
	
	generate_rarity(item, ilevel, rarity)
	return item

func generate_rarity(item: Item, ilevel, rarity):
	item.rarity = rarity
	var number_of_affixes = 0
	
	if rarity == GameEnums.RARITY.LEGENDARY:
		item.rarity = GameEnums.RARITY.LEGENDARY
		generate_legendary(item)
		return item
	elif rarity == GameEnums.RARITY.EPIC:
		item.rarity = GameEnums.RARITY.EPIC
		number_of_affixes = 3
		set_rare_name(item)
	elif rarity == GameEnums.RARITY.RARE:
		item.rarity = GameEnums.RARITY.RARE
		number_of_affixes = 2
		set_rare_name(item)
	elif rarity == GameEnums.RARITY.UNCOMMON:
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
	set_legendary(item, scales)
	
func set_legendary(item, scales):
	item.item_name = item.legendary_data.name
	item.components["legendary_stats"] = ItemLegendaryStats.new(item.legendary_data.stats, scales)
	if item.unique_data.has("usable"):
		set_usable(item, item.unique_data)

func get_usable(data_usable, item):
	return usable[data_usable.type].new(data_usable.data, item)

func set_usable(item: Item, data):
	item.components["usable"] = get_usable(data.usable, item)
	item.add_item_quantity(item.components.usable)

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
	
