extends Area2D
class_name InteractableChest

@export var world_data : WorldData
@export var id : String
@export var items : Array
@export_range(0, 14) var frame : int

@onready var sprite : Sprite2D = $Sprite2D


var action = "open"
var object_name = "Chest"
var is_open: bool = false

func _ready():
	set_sprite()

func set_sprite():
	if frame < 5:
		sprite.frame = frame
	elif frame < 10:
		sprite.frame = frame + 5
	elif frame < 15:
		sprite.frame = frame + 10

func set_items(chest: Chest):
	if world_data.chest_opened.has(id):
		var items_data = world_data.chest_opened[id]
		for i in items_data:
			chest.add_item(ItemManager.get_item_from_data(items_data[i]))
	else:
		for i in items:
			chest.add_item(ItemManager.get_item(i))

func interact():
	if !is_open:
		SignalManager.open_chest.emit(self)
		SignalManager.chest_opened.emit(self)
		sprite.frame += 5
	else:
		SignalManager.chest_closed.emit(self)
		sprite.frame -= 5

func out_of_range():
	if is_open:
		SignalManager.chest_closed.emit(self)
		sprite.frame -= 5
