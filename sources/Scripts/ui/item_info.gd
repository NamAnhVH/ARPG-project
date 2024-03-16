extends NinePatchRect
class_name ItemInfo

@export_node_path var item_name_path : NodePath
@onready var item_name : Label = get_node(item_name_path)

@export_node_path var line_container_path : NodePath
@onready var line_container = get_node(line_container_path)

var type_names = {
	GameEnums.EQUIPMENT_TYPE.NONE: "Material",
	GameEnums.EQUIPMENT_TYPE.HEAD: "Head",
	GameEnums.EQUIPMENT_TYPE.CHEST: "Chest",
	GameEnums.EQUIPMENT_TYPE.PANTS: "Pants",
	GameEnums.EQUIPMENT_TYPE.SHOES: "Shoes",
	GameEnums.EQUIPMENT_TYPE.ONE_HAND_WEAPON: "Weapon",
	GameEnums.EQUIPMENT_TYPE.SHIELD: "Shield",
	GameEnums.EQUIPMENT_TYPE.BOW: "Bow",
	GameEnums.EQUIPMENT_TYPE.SPEAR: "Spear",
	GameEnums.EQUIPMENT_TYPE.ACCESSORY: "Accessory"
}

func display(slot : InventorySlot):
	for c in line_container.get_children():
		line_container.remove_child(c)
		c.queue_free()
	
	size.x = 0
	global_position = slot.size + slot.global_position
	item_name.text = slot.item.get_item_name()
	var rarity_name = GameEnums.RARITY.keys()[slot.item.rarity].capitalize()
	var line_type = ItemInfoLine.new(rarity_name + " " + type_names[slot.item.equipment_type], ResourceManager.colors[slot.item.rarity])
	line_container.add_child(line_type)
	
	for c in slot.item.components.values():
		c.set_info(self)
	
	show()
	
	await(get_tree())
	
	var max_width = 0
	var height = 0
	for c in line_container.get_children():
		height += c.size.y
		if c.size.x > max_width:
			max_width = c.size.x + 20
	size = Vector2(max_width + 30, height)
	height += item_name.get_line_count() * 16
	size = Vector2(max_width + 30, height + 20)

func add_line(line):
	line_container.add_child(line)

