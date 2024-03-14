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
	item_name.text = slot.item.item_name
	var line_type = ItemInfoLine.new(type_names[slot.item.equipment_type], "bd9000")
	line_container.add_child(line_type)
	
	var components = slot.item.components
	
	if components.has("base_stats"):
		var base_stat_lines = components.base_stats.get_lines()
		
		for line in base_stat_lines:
			line_container.add_child(line)
	show()
	
	await(get_tree())
	
	var max_width = 0
	var height = 0
	
	for c in line_container.get_children():
		height += c.size.y + 10
		if c.size.x > max_width:
			max_width = c.size.x
	
	size = Vector2(max_width + 30, height + 8)

