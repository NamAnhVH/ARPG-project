extends ProgressBar

@export var player_data : PlayerData

var level : int

func _ready():
	SignalManager.gain_exp.connect(_on_gain_exp)
	_init_exp_bar()

func _on_gain_exp(_value):
	var new_exp = value + _value
	if new_exp >= max_value:
		player_data.level += 1
		SignalManager.level_up.emit()
		value = new_exp - max_value
		max_value = ResourceManager.level_info[str(player_data.level)].exp
	else:
		value = new_exp
	
	player_data.experience = int(value)

func _init_exp_bar():
	level = player_data.level
	max_value = ResourceManager.level_info[str(level)].exp
	value = player_data.experience
