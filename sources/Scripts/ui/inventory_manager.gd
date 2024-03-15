extends Node2D

const ITEM_OFFSET = Vector2(-12, -12)

@export var items : Array[String]

@export_node_path var item_in_hand_path : NodePath
@onready var item_in_hand_node : Control = get_node(item_in_hand_path)

@export_node_path var item_info_path : NodePath
@onready var item_info : ItemInfo = get_node(item_info_path)

@export_node_path var item_void_path : NodePath
@onready var item_void : Control = get_node(item_void_path)


var inventory: Inventory
var equipment: Equipment
var item_in_hand : Item = null
var is_open_inventory : bool = false

func _init():
	inventory = preload("res://sources/scenes/ui/inventory.tscn").instantiate()
	equipment = preload("res://sources/scenes/ui/equipment.tscn").instantiate()

func _ready():
	SignalManager.item_picked.connect(_on_item_picked)
	SignalManager.inventory_ready.connect(_on_inventory_ready)
	SignalManager.equipment_ready.connect(_on_equipment_ready)
	SignalManager.hotbar_ready.connect(_on_hotbar_ready)
	SignalManager.chest_ready.connect(_on_chest_ready)
	item_void.gui_input.connect(_on_void_gui_input)
	
	for i in items:
		inventory.add_item(ItemManager.get_item(i))

func _process(float):
	if item_in_hand:
		item_in_hand.position = get_viewport().get_mouse_position() + ITEM_OFFSET

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if !is_open_inventory:
			SignalManager.inventory_opened.emit(inventory)
			SignalManager.equipment_opened.emit(equipment)
			is_open_inventory = true
		else:
			SignalManager.inventory_closed.emit(inventory)
			SignalManager.equipment_closed.emit(equipment)
			is_open_inventory = false

func _on_inventory_ready(inventory: Inventory):
	for slot : InventorySlot in inventory.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_equipment_ready(equipment: Equipment):
	for slot : EquipmentSlot in equipment.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_hotbar_ready(hotbar: Hotbar):
	for slot : HotbarSlot in hotbar.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_chest_ready(chest: Chest):
	for slot : InventorySlot in chest.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_mouse_entered_slot(slot: InventorySlot):
	if slot.item:
		item_info.display(slot)

func _on_mouse_exited_slot():
	item_info.hide()

func _on_gui_input_slot(event: InputEvent, slot: InventorySlot):
	if slot.item and slot.item.quantity > 1 and item_in_hand == null and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT and Input.is_key_pressed(KEY_SHIFT):
		var new_quantity = slot.item.quantity / 2
		slot.item.quantity -= new_quantity
		var new_item = ItemManager.get_item(slot.item.id)
		new_item.quantity = new_quantity
		item_in_hand = new_item
		item_in_hand_node.add_child(item_in_hand)
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var had_empty_hand : bool = item_in_hand == null
		
		if item_in_hand:
			item_in_hand_node.remove_child(item_in_hand)
		
		item_in_hand = slot.put_item(item_in_hand)
		if item_in_hand:
			item_in_hand_node.add_child(item_in_hand)

func _on_item_picked(item: Item, sender: FloorItem):
	item = inventory.add_item(item)
	if not item:
		sender.item_picked()
		return

func _on_void_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and item_in_hand:
		SignalManager.item_dropped.emit(item_in_hand)
		item_in_hand_node.remove_child(item_in_hand)
		item_in_hand = null
		set_item_void_filter()

func set_item_void_filter():
	if item_in_hand:
		item_void.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	else:
		item_void.mouse_filter = Control.MOUSE_FILTER_STOP
