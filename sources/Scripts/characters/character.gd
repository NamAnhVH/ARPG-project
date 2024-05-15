extends CharacterBody2D
class_name Character

@export var move_speed_unit: float = 5: set = set_move_speed_unit
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var footstep : AudioStreamPlayer2D = $Audio/Footstep

func _ready():
	SignalManager.item_dropped.connect(_on_item_dropped)

func set_move_speed_unit(value: float):
	move_speed_unit = value

func _on_item_dropped(item):
	pass
