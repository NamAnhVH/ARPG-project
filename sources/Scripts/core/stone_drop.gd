extends Node2D
class_name StoneDrop

@onready var damage_area : DamageArea = $DamageArea
@onready var stone : Sprite2D = $Stone

var damage_amount

func _ready():
	stone.texture = ResourceManager.get_stone_drop(randi_range(0, 5))
	damage_area.damage_amount = damage_amount
