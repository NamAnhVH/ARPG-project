extends Inventory
class_name Chest

var is_open : bool = false

func _init():
	pass

func _ready():
	for s in slots:
		slot_container.add_child(s)
	SignalManager.chest_ready.emit(self)

func set_inventory_size(value):
	inventory_size = value
	for s in inventory_size:
		var slot = ResourceManager.tscn.inventory_slot.instantiate()
		slots.append(slot)

