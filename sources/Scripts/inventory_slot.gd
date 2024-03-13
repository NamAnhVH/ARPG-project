extends TextureRect
class_name InventorySlot

@export_node_path var item_container_path : NodePath
@onready var item_container : Control = get_node(item_container_path)

var item : Item

func _ready():
	if item:
		item_container.add_child(item)

func set_item(new_item: Item):
	item = new_item

func pick_item():
	item_container.remove_child(item)
	item = null

func put_item(new_item: Item):
	item = new_item
	item.position = Vector2(2, 2)
	item_container.add_child(item)
