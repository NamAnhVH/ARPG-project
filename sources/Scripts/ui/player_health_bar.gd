extends HealthBar

@export var player_data : Resource

func _ready():
	SignalManager.new_max_health.connect(_set_max_health)
	SignalManager.new_health.connect(_set_health)
	_on_data_changed()

func _init_health_bar(_max_health, _health):
	max_value = _max_health
	value = _health
	damage_bar.max_value =_max_health
	damage_bar.value = _health

func _set_max_health(max_health):
	max_value = max_health
	damage_bar.max_value = max_health

func _set_health(_health):
	set_health(_health)

func _on_data_changed():
	max_value = player_data.max_health
	value = player_data.health
	damage_bar.max_value = player_data.max_health
	damage_bar.value = player_data.health
