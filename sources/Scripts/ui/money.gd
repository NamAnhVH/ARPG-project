extends HBoxContainer

@export var player_data : PlayerData 

@onready var label : Label = $Label

func _ready():
	SignalManager.buy_item.connect(_on_decrease_money)
	SignalManager.gain_money.connect(_on_increase_money)
	player_data.changed.connect(_on_money_changed)
	_on_money_changed()

func _on_money_changed():
	label.text = str(player_data.money)

func _on_increase_money(value):
	player_data.money += value
	label.text = str(player_data.money)

func _on_decrease_money(value):
	player_data.money = clamp(player_data.money - value, 0, INF)
	label.text = str(player_data.money)

