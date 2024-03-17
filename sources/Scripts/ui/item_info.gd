extends NinePatchRect
class_name ItemInfo

@export_node_path var item_name_path : NodePath
@onready var item_name : Label = get_node(item_name_path)

@export_node_path var line_container_path : NodePath
@onready var line_container = get_node(line_container_path)

func display(slot : InventorySlot):
	for c in line_container.get_children():
		line_container.remove_child(c)
		c.queue_free()
	
	size.x = 0
	global_position = slot.size + slot.global_position
	item_name.text = slot.item.get_item_name()
	var rarity_name = GameEnums.RARITY.keys()[slot.item.rarity].capitalize()
	var line_type = ItemInfoLine.new(rarity_name + " " + ItemManager.get_type_name(slot.item), ResourceManager.colors[slot.item.rarity])
	line_container.add_child(line_type)
	
	for c in slot.item.components.values():
		c.set_info(self)
	
	
	var max_width = 0
	var height = 0
	for c in line_container.get_children():
		height += c.size.y
		if c.size.x > max_width:
			max_width = c.size.x + 20
	size = Vector2(max_width, height)
	if item_name.get_line_count() > 1:
		max_width = 120
		size = Vector2(max_width, height)
	height += item_name.get_line_count() * 16
	size = Vector2(max_width, height + 20)
	if slot is HotbarSlot:
			global_position += Vector2(0, -size.y)
	
	show()


func add_line(line):
	line_container.add_child(line)

