extends Node2D


#Xoá hết
@export var items : Array[String]
var inventory: Inventory

func _init():
	inventory = preload("res://sources/scenes/ui/inventory.tscn").instantiate()

func _ready():
	for i in items:
		inventory.add_item(ItemManager.get_item(i))
	
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		SignalManager.inventory_opened.emit(inventory)
