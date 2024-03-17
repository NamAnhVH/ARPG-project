extends InventorySlot
class_name EquipmentSlot

@export var type : GameEnums.EQUIPMENT_TYPE

@onready var placeholder : TextureRect = $Placeholder

func _ready():
	is_ready = true
	placeholder.texture = ItemManager.get_placeholder(type)

func accept_item(new_item):
	return new_item.equipment_type == type and super.accept_item(new_item)

func try_put_item(new_item: Item):
	return accept_item(new_item) and super.try_put_item(new_item)

func put_item(new_item: Item) -> Item:
	if new_item:
		if new_item.equipment_type != type:
			return new_item
		placeholder.hide()
	else:
		placeholder.show()
	
	return super.put_item(new_item)

func get_stat(stat):
	return item.get_stat(stat) if item else 0
