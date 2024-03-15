extends Area2D
class_name FloorItem

@export var item_id : String

@onready var sprite = $Sprite2D

var item : Item
var action = "pick up"
var object_name = ""

func _ready():
	if not item:
		item = ItemManager.get_item(item_id)
	
	object_name = item.item_name
	sprite.texture = ResourceManager.sprites[item.id]

func interact():
	SignalManager.item_picked.emit(item, self)

func item_picked():
	queue_free()
