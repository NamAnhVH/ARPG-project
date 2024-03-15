extends Inventory
class_name Hotbar

func _init():
	set_inventory_size(5)

func _ready():
	for s in inventory_size:
		var slot = ResourceManager.tscn.hotbar_slot.instantiate()
		slot.key = str(s + 1)
		slot_container.add_child(slot)
		slots.append(slot)
	SignalManager.hotbar_ready.emit(self)

func set_inventory_size(value):
	inventory_size = value
