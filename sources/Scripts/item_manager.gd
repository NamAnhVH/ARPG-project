extends Node

@onready var items = {
	"sword_v00" : preload("res://sources/scenes/items/sword_v00.tscn"),
	"sword_v01" : preload("res://sources/scenes/items/sword_v01.tscn")
}

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

func get_item(id: String):
	return items[id].instantiate()

func get_placeholder(id):
	return placeholders[id]
