extends HealthBar

@export var player_data : PlayerData

func _ready():
	SignalManager.new_max_health.connect(_set_max_health)
	SignalManager.new_health.connect(_set_health)
	_init_health_bar()

func _set_max_health(max_health):
	max_value = max_health
	damage_bar.max_value = max_health

func _set_health(_health):
	set_health(_health)

func _init_health_bar():
	max_value = player_data.get_stat(GameEnums.STAT.LIFE_POINT)
	value = player_data.health
	damage_bar.max_value = player_data.get_stat(GameEnums.STAT.LIFE_POINT)
	damage_bar.value = player_data.health
