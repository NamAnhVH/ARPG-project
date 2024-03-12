extends NinePatchRect
class_name ItemInfo

@export_node_path var item_name_path : NodePath
@onready var item_name : Label = get_node(item_name_path)

func display(slot : InventorySlot):
	global_position = slot.size + slot.global_position
	item_name.text = slot.item.item_name
	show()
