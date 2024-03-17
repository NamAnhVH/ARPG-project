extends InventorySlot
class_name HotbarSlot

@export_node_path var label_key_path : NodePath
@onready var label_key : Label = get_node(label_key_path)

@export_node_path var item_texture_path : NodePath
@onready var item_texture : TextureRect = get_node(item_texture_path)

var key : String
var cooldown_node : Control
var label_quantity : Label

func _ready():
	label_key.text = key
	label_quantity = ResourceManager.get_instance(("quantity"))
	label_quantity.position = Vector2(3, 0)
	add_child(label_quantity)
	
func _input(event):
	if event.is_action_pressed("hotbar_" + key) and item and item.components.has("usable"):
		item.components.usable.use()

func set_item(new_item: Item):
	if item:
		item_texture.texture = null
		item.quantity_changed.disconnect(_on_quantity_changed)
		item.depleted.disconnect(remove_item)
		label_quantity.quantity = 0
		
		var usable = item.components.usable
		usable.start_cooldown.disconnect(_on_start_cooldown)
		usable.can_use_changed.disconnect(_on_can_use_changed)
		
		if usable.is_in_cooldown:
			cooldown_node.queue_free()
	
	if new_item:
		if new_item.components.has("usable"):
			item_texture.texture = new_item.texture
			new_item.quantity_changed.connect(_on_quantity_changed)
			new_item.depleted.connect(remove_item)
			label_quantity.quantity = new_item.quantity
		
			var usable = new_item.components.usable
			usable.start_cooldown.connect(_on_start_cooldown)
			usable.can_use_changed.connect(_on_can_use_changed)
			set_enabled_color(false)
			
			if usable.is_in_cooldown:
				set_cooldown(usable)
			item = new_item
			return
	else:
		set_enabled_color(true)
		item = new_item

func remove_item_child():
	pass

func can_stack(new_item):
	return false

func put_item(new_item):
	super.put_item(new_item)
	return new_item

func set_enabled_color(value):
	modulate = Color(1, 1, 1, 1) if value else Color(0.5, 0.5, 0.5, 0.5)

func set_cooldown(usable):
	cooldown_node = usable.get_cooldown_instance()
	cooldown_node.position = Vector2(0, 0) 
	item_texture.add_child(cooldown_node)

func _on_quantity_changed(quantity):
	label_quantity.quantity = quantity

func _on_start_cooldown(usable):
	set_cooldown(usable)

func _on_can_use_changed(value):
	set_enabled_color(value)
