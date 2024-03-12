extends Node

@onready var items = {
	"sword_v00" : preload("res://sources/scenes/items/sword_v00.tscn"),
	"sword_v01" : preload("res://sources/scenes/items/sword_v01.tscn")
}

func get_item(id: String):
	return items[id].instantiate()
