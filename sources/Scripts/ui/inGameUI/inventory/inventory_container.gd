extends NinePatchRect
class_name PlayerInventory

@export var player_data : Resource

var current_inventory : Inventory

func _ready():
	SignalManager.inventory_opened.connect(_on_inventory_opened)
	SignalManager.inventory_closed.connect(_on_inventory_closed)
	SignalManager.set_inventory_data.connect(_set_inventory_data)
	SignalManager.saving_game.connect(_on_saving_game)
	player_data.changed.connect(_on_changed_data)
	get_inventory_data()
	_on_changed_data()

func get_inventory_data():
	SignalManager.get_inventory_data.emit()

func _set_inventory_data(inventory: Inventory):
	current_inventory = inventory

func _on_inventory_opened():
	InventoryManager.remove_hidden_node(current_inventory)
	for s: InventorySlot in current_inventory.slots:
		s.is_on_player = true
	add_child(current_inventory)
	show()

func _on_inventory_closed():
	if current_inventory.get_parent() == self:
		remove_child(current_inventory)
	InventoryManager.add_hidden_node(current_inventory)
	hide()

func _on_changed_data():
	current_inventory.set_data(player_data.inventory)

func _on_saving_game():
	player_data.inventory = current_inventory.get_data()
