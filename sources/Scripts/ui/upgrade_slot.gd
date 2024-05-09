extends InventorySlot
class_name UpgradeSlot

signal put_item_to_slot(item: Item)

@export var type: GameEnums.ITEM_TYPE

func set_item(new_item: Item):
	if !new_item:
		item_container.remove_child(item)
		put_item_to_slot.emit(new_item)
		item.item_slot = null
	elif is_ready:
		new_item.position = Vector2(2, 2)
		item_container.add_child(new_item)
		put_item_to_slot.emit(new_item)
		new_item.item_slot = self
	
	item = new_item

func put_item(new_item: Item) -> Item:
	#Nếu có item trên tay
	if new_item:
		if new_item.type != type:
			return new_item
		else:
			var _item = has_new_item(new_item)
			return _item
	
	#Nếu không có item trên tay, thì lấy item từ slot lên tay
	elif item:
		new_item = item
		set_item(null)
		
	return new_item

#Kiểm tra item mới có cùng là item trên slot không
func has_both_item(new_item):
	if can_stack(new_item):
		var remainder = item.add_item_quantity(new_item.quantity)
		put_item_to_slot.emit(item)
		new_item.quantity = remainder
	
	else:
		var temp_item = item
		remove_item_child()
		set_item(new_item)
		new_item = temp_item
		
	return new_item if new_item.quantity > 0 else null

