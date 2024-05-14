extends Inventory
class_name Equipment

func _init():
	set_inventory_size(9)

func _ready():
	for slot : EquipmentSlot in slot_container.get_children():
		slots.append(slot)
	
	SignalManager.equipment_ready.emit()
	for s in slots:
		s.is_on_player_equipment = true

func set_inventory_size(value):
	inventory_size = value

func get_stat(stat):
	var total = 0
	for slot in slots:
		total += slot.get_stat(stat) 
	return total
