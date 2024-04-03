extends CanvasLayer

var is_open_inventory : bool = false
@onready var window : Control = $Window

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if !is_open_inventory:
			SignalManager.inventory_opened.emit()
			is_open_inventory = true
			window.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			SignalManager.inventory_closed.emit()
			is_open_inventory = false
			window.mouse_filter = Control.MOUSE_FILTER_IGNORE
