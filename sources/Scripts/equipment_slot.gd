extends InventorySlot
class_name EquipmentSlot

@export var type : GameEnums.EQUIPMENT_TYPE

@export_node_path var placeholder_path : NodePath
@onready var placeholder : Control = get_node(placeholder_path)

func _ready():
	placeholder.texture = ItemManager.get_placeholder(type)

func set_item(new_item: Item):
	item = new_item
	placeholder.hide()

func pick_item():
	item_container.remove_child(item)
	item = null
	placeholder.show()

func put_item(new_item: Item):
	item = new_item
	item.position = Vector2(2, 2)
	item_container.add_child(item)
	placeholder.hide()
