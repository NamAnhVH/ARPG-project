extends NinePatchRect
class_name ItemInfo

@onready var item_name : Label = $ItemName
@onready var line_container = $LineContainer

func display(slot):
	for c in line_container.get_children():
		line_container.remove_child(c)
		c.queue_free()
	
	size.x = 0
	global_position = slot.size + slot.global_position
	item_name.text = slot.item.item_name
	if slot.item.upgrade_level > 0:
		item_name.text += " +" + str(slot.item.upgrade_level)
		
	item_name.label_settings = ResourceManager.set_font(16, ResourceManager.colors[slot.item.rarity])
	var rarity_name = GameEnums.RARITY.keys()[slot.item.rarity].capitalize()
	var line_type = ItemInfoLine.new(rarity_name + " " + ItemManager.get_type_name(slot.item), slot.item.rarity)
	line_container.add_child(line_type)
	
	
	for c in slot.item.components.values():
		c.set_info(self)
	
	var max_width = 0
	var height = 0
	for c in line_container.get_children():
		height += c.size.y + 4
		if c.size.x > max_width:
			max_width = c.size.x + 20
	size = Vector2(max_width, height)
	if item_name.get_line_count() > 1:
		max_width = 120
		size = Vector2(max_width, height)
	height += item_name.get_line_count() * 20
	size = Vector2(max_width + 10, height)
	if slot is HotbarSlot:
			global_position += Vector2(0, -size.y)
	
	show()

func display_shop_item(slot):
	for c in line_container.get_children():
		line_container.remove_child(c)
		c.queue_free()
	
	size.x = 60
	item_name.text = ItemManager.get_item_name(slot.item_id)
	item_name.label_settings = ResourceManager.set_font(16, ResourceManager.colors[GameEnums.RARITY.COMMON])
	var line_type = ItemInfoLine.new(ItemManager.get_type_name_with_id(slot.item_id), GameEnums.RARITY.COMMON)
	line_container.add_child(line_type)
	
	var max_width = 0
	var height = 0
	for c in line_container.get_children():
		height += c.size.y + 4
		if c.size.x > max_width:
			max_width = c.size.x + 20
	size = Vector2(max_width, height)
	if item_name.get_line_count() > 1:
		max_width = 120
		size = Vector2(max_width, height)
	height += item_name.get_line_count() * 20
	size = Vector2(max_width + 10, height)
	
	global_position = slot.global_position - size
	
	show()

func add_line(line):
	line_container.add_child(line)

