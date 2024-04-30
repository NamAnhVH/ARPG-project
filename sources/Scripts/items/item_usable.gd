extends Node
class_name ItemUsable

signal start_cooldown(item_usable)
signal cooldown_tick(cooldown_remaining)
signal can_use_changed(can_use)

var unlimited_use : bool = false
var cooldown = 1
var cooldown_remaining = 0
var is_in_cooldown : bool = false
var can_use : bool = false : set = set_can_use, get = get_can_use
var can_always_use : bool = false
var on_use_text = ""
var amount
var type

var item : Item

func _init(data, parent_item: Item, usable_type):
	type = usable_type
	item = parent_item
	set_data(data)
	item.item_placed_in_player_inventory.connect(_on_item_placed_in_player_inventory)

func _process(delta):
	if is_in_cooldown:
		cooldown_remaining -= delta
		cooldown_tick.emit(cooldown_remaining)
	
	if cooldown_remaining <= 0:
		is_in_cooldown = false

func set_data(data):
	amount = data.value
	if data.has("unlimited_use"): unlimited_use = data.unlimited_use
	if data.has("cooldown"): cooldown = data.cooldown

func use():
	if get_can_use() and !is_in_cooldown:
		execute()
	
		if !unlimited_use:
			item.quantity -= 1
		
		is_in_cooldown = true
		cooldown_remaining = cooldown
		item.add_child(get_cooldown_instance())
		start_cooldown.emit(self)

func execute():
	pass

func get_cooldown_instance():
	var cooldown_node = ResourceManager.get_instance("cooldown")
	cooldown_node.set_data(self)
	return cooldown_node

func _on_item_placed_in_player_inventory(value):
	can_use_changed.emit(get_can_use())

func get_use_text():
	pass

func set_info(item_info):
	item_info.add_line(ItemInfoLine.new("On use:", GameEnums.RARITY.COMMON))
	item_info.add_line(ItemInfoLine.new(get_use_text(), item.rarity))

func set_can_use(value):
	can_use = value
	can_use_changed.emit(get_can_use())

func get_can_use():
	return (can_use or can_always_use) and item.item_slot and item.item_slot is EquipmentSlot and item.item_slot.is_on_player_equipment
