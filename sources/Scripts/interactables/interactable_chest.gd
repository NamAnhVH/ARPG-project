extends Area2D
class_name InteractableChest

@export var items : Array[String]
@export_range(0, 14) var frame : int

@onready var sprite : Sprite2D = $Sprite2D

var chest : Chest
var action = "open"
var object_name = "Chest"

func _init():
	chest = preload("res://sources/scenes/ui/chest.tscn").instantiate()

func _ready():
	set_sprite()
	set_items()

func set_sprite():
	if frame < 5:
		sprite.frame = frame
	elif frame < 10:
		sprite.frame = frame + 5
	elif frame < 15:
		sprite.frame = frame + 10

func set_items():
	for i in items:
		chest.add_item(ItemManager.get_item(i))

func interact():
	if !chest.is_open:
		SignalManager.chest_opened.emit(chest)
		sprite.frame += 5
	else:
		SignalManager.chest_closed.emit(chest)
		sprite.frame -= 5

func out_of_range():
	if chest.is_open:
		SignalManager.chest_closed.emit(chest)
		sprite.frame -= 5
