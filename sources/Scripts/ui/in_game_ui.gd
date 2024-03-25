extends CanvasLayer

var is_open_inventory : bool = false

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if !is_open_inventory:
			SignalManager.inventory_opened.emit()
			is_open_inventory = true
		else:
			SignalManager.inventory_closed.emit()
			is_open_inventory = false
