extends CanvasLayer

const ITEM_OFFSET = Vector2(-12, -12)

@export var player_data : PlayerData
@export var world_data : WorldData

@onready var item_in_hand_node : Control = $ItemInHand
@onready var item_info : ItemInfo = $ItemInfo
@onready var item_void : Control = $CanvasLayer/ItemVoid
@onready var hidden_nodes : Control = $HiddenNodes

var inventory: Inventory
var equipment: Equipment
var item_in_hand : Item = null

#Build
func _ready():
	inventory = ResourceManager.get_instance("inventory")
	equipment = ResourceManager.get_instance("equipment")
	
	SignalManager.inventory_ready.connect(_on_inventory_ready)
	SignalManager.equipment_ready.connect(_on_equipment_ready)
	SignalManager.hotbar_ready.connect(_on_hotbar_ready)
	SignalManager.chest_ready.connect(_on_chest_ready)
	SignalManager.shop_ready.connect(_on_shop_ready)
	SignalManager.upgrade_ready.connect(_on_upgrade_ready)
	SignalManager.sell_item_ready.connect(_on_sell_item_ready)
	
	item_void.gui_input.connect(_on_void_gui_input)
	
	SignalManager.get_inventory_data.connect(_get_inventory_data)
	SignalManager.get_equipment_data.connect(_get_equipment_data)
	
	SignalManager.inventory_add_item.connect(_on_inventory_add_item)
	
	InventoryManager.add_hidden_node(inventory)
	InventoryManager.add_hidden_node(equipment)


func _process(delta):
	if item_in_hand:
		item_in_hand.position = get_viewport().get_mouse_position() + ITEM_OFFSET
		item_void.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		item_void.mouse_filter = Control.MOUSE_FILTER_IGNORE

#Function
func has_space_for_item(items_data):
	var item = ItemManager.get_items(items_data)
	item = inventory.try_place_stack_item(item)
	item = inventory.accept_item(item)
	return item

func add_item(item):
	item = inventory.add_item(item)

func split_item(item):
	var new_quantity = item.quantity / 2
	item.quantity -= new_quantity
	var new_item = ItemManager.get_item(item.id)
	new_item.quantity = new_quantity
	item_in_hand = new_item
	item_in_hand_node.add_child(item_in_hand)

func add_hidden_node(node):
	if node and node.get_parent() != hidden_nodes:
		hidden_nodes.add_child(node)

func remove_hidden_node(node):
	if node and node.get_parent() == hidden_nodes:
		hidden_nodes.remove_child(node)

#Signal Function
func _get_inventory_data():
	SignalManager.set_inventory_data.emit(inventory)

func _get_equipment_data():
	SignalManager.set_equipment_data.emit(equipment)

func _on_inventory_ready():
	for slot : InventorySlot in inventory.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_equipment_ready():
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

func _on_shop_ready(shop: Shop):
	for s : ShopSlotContainer in shop.list_item_container.get_children():
		s.slot.mouse_entered.connect(_on_mouse_entered_shop_slot.bind(s.slot))
		s.slot.mouse_exited.connect(_on_mouse_exited_slot)
		s.slot.gui_input.connect(_on_gui_input_shop_slot.bindv([s]))

func _on_sell_item_ready(sell: SellItem):
	for slot in sell.slot_container.get_children():
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited_slot)
		slot.gui_input.connect(_on_gui_input_slot.bindv([slot]))

func _on_upgrade_ready(upgrade: Upgrade):
	upgrade.upgrade_slot.mouse_entered.connect(_on_mouse_entered_slot.bind(upgrade.upgrade_slot))
	upgrade.upgrade_slot.mouse_exited.connect(_on_mouse_exited_slot)
	upgrade.upgrade_slot.gui_input.connect(_on_gui_input_slot.bindv([upgrade.upgrade_slot]))
	
	upgrade.material_slot.mouse_entered.connect(_on_mouse_entered_slot.bind(upgrade.material_slot))
	upgrade.material_slot.mouse_exited.connect(_on_mouse_exited_slot)
	upgrade.material_slot.gui_input.connect(_on_gui_input_slot.bindv([upgrade.material_slot]))

func _on_mouse_entered_slot(slot: InventorySlot):
	if slot.item:
		item_info.display(slot)

func _on_mouse_entered_shop_slot(slot):
	if slot.item:
		item_info.display_shop_item(slot)

func _on_mouse_exited_slot():
	item_info.hide()

func _on_gui_input_slot(event: InputEvent, slot: InventorySlot):
	if slot.item \
	and slot.item.quantity > 1 \
	and item_in_hand == null \
	and event is InputEventMouseButton \
	and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and Input.is_key_pressed(KEY_SHIFT):
		split_item(slot.item)
	elif event is InputEventMouseButton \
	and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if item_in_hand:
				item_in_hand_node.remove_child(item_in_hand)
			
			item_in_hand = slot.put_item(item_in_hand)
			if slot is EquipmentSlot:
				player_data.equipment = equipment.get_data()
			elif slot is ChestSlot:
				SignalManager.chest_updated.emit()
			elif slot is InventorySlot:
				player_data.inventory = inventory.get_data()
			if item_in_hand:
				item_in_hand_node.add_child(item_in_hand)
		elif event.button_index == MOUSE_BUTTON_RIGHT \
		and slot.item \
		and slot.item.components.has("usable"):
			slot.item.components.usable.use()
	
	if slot.item:
		slot.mouse_entered.emit()
	else:
		slot.mouse_exited.emit()

func _on_gui_input_shop_slot(event: InputEvent, slot):
	if event is InputEventMouseButton \
	and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT:
		if player_data.money >= slot.price:
			if item_in_hand:
				if item_in_hand.id == slot.item_id and ItemManager.can_stack(slot.item_id, item_in_hand.quantity + slot.quantity):
					item_in_hand.quantity += slot.quantity
					SignalManager.buy_item.emit(slot.price)
			else:
				item_in_hand = ItemManager.get_item(slot.item_id)
				item_in_hand.quantity = slot.quantity
				item_in_hand_node.add_child(item_in_hand)
				SignalManager.buy_item.emit(slot.price)

func _on_void_gui_input(event):
	if event is InputEventMouseButton \
	and event.is_pressed() \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and item_in_hand:
		item_in_hand_node.remove_child(item_in_hand)
		SignalManager.item_dropped.emit(item_in_hand)
		item_in_hand = null

func _on_clear_hidden_node():
	for c in hidden_nodes.get_children():
		c.queue_free()

func _on_inventory_add_item(item: Item):
	inventory.add_item(item)

func is_have_items_for_quest(quest_id,type_quest):
	var items = []
	if type_quest == GameEnums.QUEST_TYPE.MAIN_QUEST:
		items = StoryManager.progress_data.current_main_quest.progress.give.duplicate()
		#print_debug(StoryManager.progress_data.current_main_quest.progress)
	if type_quest == GameEnums.QUEST_TYPE.SIDE_QUEST:
		items = StoryManager.progress_data.current_side_quest[quest_id].progress.give
	for item in items:
		for slot: InventorySlot in inventory.slots:
			if slot.item and slot.item.id == item.item_id:
				if slot.item.quantity == item.quantity:
					slot.set_item(null)
					items.erase(item)
					break
				elif slot.item.quantity > item.quantity:
					slot.item.quantity -= item.quantity
					items.erase(item)
					break
	return true if items.is_empty() else false
