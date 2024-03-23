extends NinePatchRect
class_name Shop

@onready var list_item_container : VBoxContainer = $MainContainer/ListItemContainer

func _ready():
	SignalManager.shop_opened.connect(_on_shop_opened)
	SignalManager.shop_closed.connect(_on_shop_closed)

func _on_shop_opened(new_list_item: Array[Dictionary]):
	for item in new_list_item:
		var shop_slot_container = ResourceManager.get_instance("shop_slot_container")
		shop_slot_container.price = item.price
		shop_slot_container.item_id = item.item_id
		shop_slot_container.quantity = item.quantity if item.has("quantity") else 1
		list_item_container.add_child(shop_slot_container)
	show()
	SignalManager.shop_ready.emit(self)

func _on_shop_closed():
	hide()
	for item in list_item_container.get_children():
		item.queue_free()
