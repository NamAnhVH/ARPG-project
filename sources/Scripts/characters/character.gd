extends CharacterBody2D
class_name Character

func _ready():
	SignalManager.item_dropped.connect(_on_item_dropped)

func _on_item_dropped(item):
	pass
