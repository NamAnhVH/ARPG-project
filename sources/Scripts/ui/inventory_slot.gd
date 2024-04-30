extends TextureRect
class_name InventorySlot

@onready var item_container : Control = $ItemContainer

var item : Item : set = set_item
var is_ready : bool = false
var is_on_player : bool

func _ready():
	is_ready = true
	if item:
		item_container.add_child(item)
		item.item_slot = self

func set_item(new_item: Item):
	if !new_item:
		item_container.remove_child(item)
		item.item_slot = null
	elif is_ready:
		new_item.position = Vector2(2, 2)
		item_container.add_child(new_item)
		new_item.item_slot = self
	
	item = new_item
	SignalManager.update_stat.emit()

func accept_item(new_item):
	return new_item and !item

#Check xem item có thể được thêm vào slot không
func try_put_item(new_item: Item):
	return accept_item(new_item) or (item.id == new_item.id and item.quantity < item.stack_size)

#Thêm Item vào slot
func put_item(new_item: Item) -> Item:
	#Nếu có item trên tay
	if new_item:
		return has_new_item(new_item)
	
	#Nếu không có item trên tay, thì lấy item từ slot lên tay
	elif item:
		new_item = item
		set_item(null)
		
	return new_item

func has_new_item(new_item):
	if item:
		return has_both_item(new_item)
	else:
		set_item(new_item)
		return null

#Kiểm tra item mới có cùng là item trên slot không
func has_both_item(new_item):
	if can_stack(new_item):
		var remainder = item.add_item_quantity(new_item.quantity)
		new_item.quantity = remainder
	
	else:
		var temp_item = item
		remove_item_child()
		set_item(new_item)
		new_item = temp_item
		
	return new_item if new_item.quantity > 0 else null

#Kiểm tra item có thể stack không
func can_stack(new_item):
	return item.id == new_item.id and item.quantity < item.stack_size

func remove_item_child():
	item_container.remove_child(item)

func remove_item():
	var old_item = put_item(null)
	if old_item:
		old_item.queue_free()
