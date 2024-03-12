extends TextureRect
class_name InventorySlot

@export_node_path var item_container_path : NodePath
@onready var item_container : Control = get_node(item_container_path)

var item : Item

func _ready():
	if item:
		item_container.add_child(item)

func set_item(new_item):
	item = new_item

func pick_item():
	item.is_pick_up()
	item_container.remove_child(item)
	item = null

func put_item(new_item: Item):
	item = new_item
	item.position = Vector2(2, 2)
	item.is_put_down()
	item_container.add_child(item)
