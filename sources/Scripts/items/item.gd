extends TextureRect
class_name Item

signal item_placed_in_player_inventory(is_on_player: bool)
signal quantity_changed(quantity: int)
signal depleted()

var id : String
var type
var item_name : String
var rarity = GameEnums.RARITY.COMMON
var equipment_type : GameEnums.EQUIPMENT_TYPE
var weapon_type: GameEnums.WEAPON_TYPE
var extra_weapon_type: GameEnums.EXTRA_WEAPON_TYPE
var stack_size : int = 1
var quantity: int = 1 : set = set_quantity
var level: int = 1
var upgrade_level : int = 0
var components = {}
var lbl_quantity : Label
var legendary_data
var item_slot : set = set_item_slot
var item_data

func _init(item_id: String, data):
	size = Vector2(28, 28)
	position = Vector2(2, 2)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	id = item_id
	texture = ResourceManager.sprites[id]
	
	item_data = data
	item_name = data.name
	level = data.level
	type = GameEnums.ITEM_TYPE[data.type]
	if type == GameEnums.ITEM_TYPE.EQUIPMENT:
		equipment_type = GameEnums.EQUIPMENT_TYPE[data.equipment_type]
		if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
			weapon_type = GameEnums.WEAPON_TYPE[data.weapon_type]
		if equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
			extra_weapon_type = GameEnums.EXTRA_WEAPON_TYPE[data.extra_weapon_type]

	rarity = GameEnums.RARITY[data.rarity] if data.has("rarity") else GameEnums.RARITY.COMMON
	if data.has("stack_size"): stack_size = data.stack_size
	if data.has("base_stats"): components["base_stats"] = BaseStat.new(data.base_stats, rarity)
	if data.has("legendary"): legendary_data = data.legendary

func _ready():
	lbl_quantity = ResourceManager.get_instance("quantity")
	add_child(lbl_quantity)
	lbl_quantity.quantity = quantity
	
	if item_data.has("usable"):
		components["usable"] = ItemManager.get_usable(item_data.usable, self)
		add_child(components.usable)

func set_quantity(value):
	quantity = value
	quantity_changed.emit(quantity)
	
	if lbl_quantity:
		lbl_quantity.quantity = quantity
	
	if quantity <= 0:
		depleted.emit()
		destroy()

func add_item_quantity(value):
	var remainder = quantity + value - stack_size
	quantity = min(quantity + value, stack_size)
	set_quantity(quantity)
	return remainder

func set_item_slot(value):
	item_slot = value
	item_placed_in_player_inventory.emit(item_slot.is_on_player if item_slot else false)

func destroy():
	if item_slot:
		item_slot.remove_item()
	else:
		queue_free()

func upgrade():
	upgrade_level += 1
	components["base_stats"].upgrade()
	

func get_data():
	var data = {
		"id": id,
		"item_name": item_name,
		"rarity": rarity,
		"quantity": quantity,
		"components": {},
		"upgrade_level": upgrade_level
		}
	
	for c in components:
		if components[c].has_method("get_data"):
			data.components[c] = components[c].get_data()
	return data

func get_stat(stat):
	var total = 0
	for c in components:
		if components[c].has_method("get_stat"):
			total += components[c].get_stat(stat)
	return total
