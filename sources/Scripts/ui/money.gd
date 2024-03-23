extends HBoxContainer

@export var player_data : Resource 

@onready var label : Label = $Label

func _ready():
	SignalManager.buy_item.connect(_on_decrease_money)
	player_data.changed.connect(_on_money_changed)
	_on_money_changed()

func _on_money_changed():
	label.text = str(player_data.money)

func _on_decrease_money(value):
	player_data.money -= value
	label.text = str(player_data.money)

