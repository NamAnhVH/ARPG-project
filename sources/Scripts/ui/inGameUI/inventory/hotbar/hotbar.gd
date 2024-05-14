extends Inventory
class_name Hotbar

func _init():
	set_inventory_size(5)

func _ready():
	for i in inventory_size:
		var slot = ResourceManager.get_instance("hotbar_slot")
		slot.key = str(i + 1)
		slot_container.add_child(slot)
		slots.append(slot)
	SignalManager.hotbar_ready.emit(self)
	
	for s in slots:
		s.is_on_player = true

func set_inventory_size(value):
	inventory_size = value
