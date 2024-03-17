extends NinePatchRect

var current_chest : Chest

func _ready():
	SignalManager.chest_opened.connect(_on_chest_opened)
	SignalManager.chest_closed.connect(_on_chest_closed)

func _on_chest_opened(chest: Chest):
	chest.is_open = true
	current_chest = chest
	InventoryManager.remove_hidden_node(current_chest)
	add_child(current_chest)
	show()

func _on_chest_closed(chest: Chest):
	chest.is_open = false
	remove_child(current_chest)
	InventoryManager.add_hidden_node(current_chest)
	hide()

