extends InventorySlot
class_name HotbarSlot

@export_node_path var label_key_path : NodePath
@onready var label_key : Label = get_node(label_key_path)

var key

func _ready():
	is_ready = true
	label_key.text = key
	
func _input(event):
	if event.is_action_pressed("hotbar_" + key):
		print(key)

func try_put_item(new_item: Item):
	return new_item.equipment_type == GameEnums.EQUIPMENT_TYPE.NONE and super.try_put_item(new_item)

func put_item(new_item: Item) -> Item:
	if new_item:
		if new_item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
			return new_item

	return super.put_item(new_item)
