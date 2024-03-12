extends NinePatchRect

var current_inventory : Inventory

func _ready():
	SignalManager.inventory_opened.connect(_on_inventory_opened)

func close():
	remove_child(current_inventory)
	hide()

func _on_inventory_opened(inventory: Inventory):
	current_inventory = inventory
	add_child(current_inventory)
	show()
