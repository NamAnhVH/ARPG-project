extends NinePatchRect
class_name Inventory

@export var inventory_size : int = 28 : set = set_inventory_size

@export_node_path var slot_container_path : NodePath
@onready var slot_container : Control = get_node(slot_container_path)

var slots : Array = []


func _init():
	set_inventory_size(28)

func _ready():
	for s in slots:
		slot_container.add_child(s)
	
	SignalManager.inventory_ready.emit(self)

func set_inventory_size(value):
	inventory_size = value
	
	for s in inventory_size:
		var new_slot = ResourceManager.tscn.inventory_slot.instantiate()
		slots.append(new_slot)

func add_item(item: Item):
	for s in slots:
		if s.try_put_item(item):
			item = s.put_item(item)
			
			if not item:
				return null
	return item
