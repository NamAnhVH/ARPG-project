extends TextureRect
class_name Item

var id : String
var item_name : String
var equipment_type : GameEnums.EQUIPMENT_TYPE
var stack_size = 1
var quantity = 1 : set = set_quantity
var level = 1
var components = {}
var lbl_quantity : Label


func _init(item_id: String, data):
	size = Vector2(28,28)
	position = Vector2(2,2)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	id = item_id
	item_name = data.name
	level = data.level
	texture = ResourceManager.sprites[id]
	
	if data.has("stack_size"):
		stack_size = data.stack_size
	
	if data.has("type"):
		equipment_type = GameEnums.EQUIPMENT_TYPE[data.type]
	
	if data.has("base_stats"):
		components["base_stats"] = BaseStat.new(data.base_stats, randf())

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
