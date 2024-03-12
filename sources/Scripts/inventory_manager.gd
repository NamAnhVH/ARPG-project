extends Node2D

const ITEM_OFFSET = Vector2(-12, -12)

@export_node_path var item_in_hand_path : NodePath
@onready var item_in_hand_node : Control = get_node(item_in_hand_path)

@export_node_path var item_info_path : NodePath
@onready var item_info : ItemInfo = get_node(item_info_path)

var item_in_hand = null

func _process(float):
	if item_in_hand:
		item_in_hand.position = get_viewport().get_mouse_position() + ITEM_OFFSET

func _ready():
	SignalManager.inventory_ready.connect(_on_inventory_ready)

func _on_inventory_ready(inventory: Inventory):
	for slot : InventorySlot in inventory.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_mouse_entered_slot(slot: InventorySlot):
	if slot.item:
		item_info.display(slot)

func _on_mouse_exited_slot():
	item_info.hide()

func _on_gui_input_slot(event: InputEvent, slot: InventorySlot):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if item_in_hand:
			item_in_hand_node.remove_child(item_in_hand)
			if slot.item:
				var temp_item = slot.item
				slot.pick_item()
				temp_item.global_position = event.global_position
				slot.put_item(item_in_hand)
				item_in_hand = temp_item
				item_in_hand_node.add_child(item_in_hand)
			else:
				slot.put_item(item_in_hand)
				item_in_hand = null
			
		elif slot.item:
			item_in_hand = slot.item
			slot.pick_item()
			item_in_hand_node.add_child(item_in_hand)
