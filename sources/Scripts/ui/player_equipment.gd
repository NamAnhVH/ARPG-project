extends NinePatchRect

var current_equipment : Equipment

@export var player_data : PlayerData

func _ready():
	SignalManager.inventory_opened.connect(_on_equipment_opened)
	SignalManager.inventory_closed.connect(_on_equipment_closed)
	SignalManager.set_equipment_data.connect(_set_equipment_data)
	SignalManager.saving_game.connect(_on_saving_game)
	player_data.changed.connect(_on_changed_data)
	get_equipment_data()
	_on_changed_data()

func get_equipment_data():
	SignalManager.get_equipment_data.emit()

func _set_equipment_data(equipment: Equipment):
	current_equipment = equipment

func _on_equipment_opened():
	InventoryManager.remove_hidden_node(current_equipment)
	add_child(current_equipment)
	show()

func _on_equipment_closed():
	if get_child_count() > 0:
		remove_child(current_equipment)
	InventoryManager.add_hidden_node(current_equipment)
	hide()

func _on_changed_data():
	current_equipment.set_data(player_data.equipment)

func _on_saving_game():
	player_data.equipment = current_equipment.get_data()
