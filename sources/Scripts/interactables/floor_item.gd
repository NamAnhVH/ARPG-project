extends Area2D
class_name FloorItem

@export var item_id : String

@onready var sprite = $Sprite2D

var item : Item
var action = "pick up"
var object_name = ""

func _ready():
	if !item:
		item = ItemManager.get_item(item_id)
	
	object_name = item.item_name
	sprite.texture = ResourceManager.sprites[item.id]
	InventoryManager.add_hidden_node(item)

func interact():
	if InventoryManager.has_space_for_items([item.get_data()]):
		InventoryManager.remove_hidden_node(item)
		InventoryManager.add_items([item])
		queue_free()
