extends NinePatchRect
class_name SellItem

@onready var slot_container : GridContainer = $MainContainer/SlotContainer

func _ready():
	SignalManager.sell_item_opened.connect(_on_sell_item_opened)
	SignalManager.sell_item_closed.connect(_on_sell_item_closed)
	SignalManager.sell_item_ready.emit(self)

func _on_sell_item_opened():
	Global.is_sell_item_opened = true
	show()

func _on_sell_item_closed():
	Global.is_sell_item_opened = false
	for slot in slot_container.get_children():
		if slot.item:
			var item = slot.item
			slot.set_item(null)
			SignalManager.inventory_add_item.emit(item)
	hide()

func _on_sell_button_pressed():
	var total_value = 0
	for slot in slot_container.get_children():
		if slot.item:
			total_value += ((slot.item.level / 5 + 1) * 5) * slot.item.quantity
			slot.item.queue_free()
			slot.set_item(null)
	SignalManager.gain_money.emit(total_value)
