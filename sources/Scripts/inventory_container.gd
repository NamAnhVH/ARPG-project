extends NinePatchRect

var current_inventory : Inventory

func _ready():
	SignalManager.inventory_opened.connect(_on_inventory_opened)
	SignalManager.inventory_closed.connect(_on_inventory_closed)

func _on_inventory_opened(inventory: Inventory):
	current_inventory = inventory
	add_child(current_inventory)
	show()

func _on_inventory_closed(inventory: Inventory):
	remove_child(current_inventory)
	hide()
