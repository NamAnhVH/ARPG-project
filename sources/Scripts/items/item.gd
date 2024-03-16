extends TextureRect
class_name Item

var id : String
var item_name : String
var rarity = GameEnums.RARITY.COMMON
var equipment_type : GameEnums.EQUIPMENT_TYPE
var stack_size = 1
var quantity = 1 : set = set_quantity
var level = 1
var components = {}
var lbl_quantity : Label
var legendary_data

func _init(item_id: String, data):
	size = Vector2(28,28)
	position = Vector2(2,2)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	id = item_id
	item_name = data.name
	level = data.level
	texture = ResourceManager.sprites[id]
	
	if data.has("rarity"):
		rarity = GameEnums.RARITY[data.rarity]
	
	if data.has("stack_size"):
		stack_size = data.stack_size
	
	if data.has("type"):
		equipment_type = GameEnums.EQUIPMENT_TYPE[data.type]
	
	if data.has("base_stats"):
		components["base_stats"] = BaseStat.new(data.base_stats)
	
	if data.has("legendary"):
		legendary_data = data.legendary

func _ready():
	lbl_quantity = Label.new()
	lbl_quantity.label_settings = ResourceManager.set_font(15)
	lbl_quantity.size = Vector2(26, 26)
	lbl_quantity.position = Vector2(1, -2)
	lbl_quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(lbl_quantity)
	set_quantity(quantity)

func set_quantity(value):
	quantity = value
	
	if lbl_quantity:
		lbl_quantity.text = str(quantity)
		lbl_quantity.visible = quantity > 1

func add_item_quantity(value):
	var remainder = quantity + value - stack_size
	quantity = min(quantity + value, stack_size)
	set_quantity(quantity)
	return remainder

func get_item_name():
	if components.has("affix_list") and rarity != GameEnums.RARITY.COMMON:
		var prefix = ""
		var suffix = ""
		
		for affix_item in components.affix_list.affixes:
			if affix_item.affix_group.type == GameEnums.AFFIX_TYPE.PREFIX:
				prefix = affix_item.affix.affix_name
			else:
				suffix = affix_item.affix.affix_name
		return("%s %s %s" % [prefix, item_name, suffix]).strip_edges()
	return item_name
