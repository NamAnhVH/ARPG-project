extends NinePatchRect
class_name Inventory

@export var inventory_size : int = 28 : set = set_inventory_size

@onready var slot_container : Control = $SlotContainer

var slots : Array = []

#Build
func _init():
	set_inventory_size(28)

func _ready():
	for s in slots:
		slot_container.add_child(s)
	
	SignalManager.inventory_ready.emit()

#Setget
func set_inventory_size(value):
	inventory_size = value
	
	for s in inventory_size:
		var new_slot = ResourceManager.get_instance("inventory_slot")
		slots.append(new_slot)

#Function
func add_item(item: Item):
	if item.stack_size > 1:
		for s in slots:
			if s.item and s.item.id == item.id and s.item.quantity < s.item.stack_size:
				item = s.put_item(item)
				if item == null:
					break
	
	if item:
		for s in slots:
			if s.try_put_item(item):
				item = s.put_item(item)
				
				if !item:
					return null
	return item

func try_place_stack_item(item: Item):
	for s in slots:
		if s.item and s.item.quantity < s.item.stack_size:
			var free_space = s.item.stack_size - s.item.quantity
			if s.item.id == item.id:
				if item.quantity <= free_space:
					free_space -= item.quantity
					var temp = item
					temp.queue_free()
				else:
					item.quantity -= free_space
	return item

func accept_item(item):
	for s in slots:
		if s.accept_item(item):
			var temp = item
			temp.queue_free()
	return item

func get_data():
	var data = {}
	for s in slots.size():
		if slots[s].item:
			data[s] = slots[s].item.get_data()
	return data

func set_data(data):
	for i in slots.size():
		var old_item = slots[i].put_item(null)
		if old_item:
			old_item.queue_free()
		if data.has(i):
			slots[i].put_item(ItemManager.get_item_from_data(data[i]))
