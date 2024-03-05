extends CharacterBody2D
class_name BattleCharacter

@export var move_speed_unit: float = 5: set = set_move_speed_unit, get = get_move_speed_unit

@onready var hitbox = $Hitbox

func set_move_speed_unit(value: float):
	move_speed_unit = value

func get_move_speed_unit():
	return move_speed_unit
