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
	
	#Nếu có item trên tay
	if new_item:
		return has_new_item(new_item)
	
	#Nếu không có item trên tay, thì lấy item từ slot lên tay
	elif item:
		SignalManager.unequip_item.emit(item.equipment_type)
		new_item = item
		set_item(null)
		
	return new_item

func has_new_item(new_item):
	SignalManager.equip_item.emit(new_item)
	if item:
		var temp_item = item
		remove_item_child()
		set_item(new_item)
		new_item = temp_item
		return new_item
	else:
		set_item(new_item)
		return null


func get_stat(stat):
	return item.get_stat(stat) if item else 0
