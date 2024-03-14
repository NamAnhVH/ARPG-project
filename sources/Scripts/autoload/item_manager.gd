extends Node

const ITEM_PATH : String = "res://sources/scenes/items/items.json"

var items = {}

@onready var placeholders = {
	GameEnums.EQUIPMENT_TYPE.HEAD : preload("res://assets/placeholders/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST : preload("res://assets/placeholders/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.PANTS : preload("res://assets/placeholders/placeholder_pants.png"),
	GameEnums.EQUIPMENT_TYPE.SHOES : preload("res://assets/placeholders/placeholder_shoes.png"),
	GameEnums.EQUIPMENT_TYPE.ONE_HAND_WEAPON : preload("res://assets/placeholders/placeholder_one_hand_weapon.png"),
	GameEnums.EQUIPMENT_TYPE.SHIELD : preload("res://assets/placeholders/placeholder_shield.png"),
	GameEnums.EQUIPMENT_TYPE.ACCESSORY : preload("res://assets/placeholders/placeholder_accessory.png"),
	GameEnums.EQUIPMENT_TYPE.BOW : preload("res://assets/placeholders/placeholder_bow.png"),
	GameEnums.EQUIPMENT_TYPE.SPEAR : preload("res://assets/placeholders/placeholder_spear.png")
}

func _ready():
	var file = FileAccess.open(ITEM_PATH, FileAccess.READ)
	items = JSON.parse_string(file.get_as_text())
	file.close()

func get_item(id: String):
	return Item.new(id, items[id])

func get_placeholder(id):
	return placeholders[id]
