extends Inventory
class_name Chest

func _init():
	pass

func _ready():
	for s in slots:
		slot_container.add_child(s)
	SignalManager.chest_ready.emit(self)

func set_inventory_size(value):
	inventory_size = value
	for s in inventory_size:
		var slot = ResourceManager.get_instance("chest_slot")
		slots.append(slot)

