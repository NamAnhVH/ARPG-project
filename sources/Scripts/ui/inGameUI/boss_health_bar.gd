extends HealthBar

var current_boss

func _process(delta):
	if current_boss == null:
		hide()

func _ready():
	SignalManager.new_boss_health.connect(_set_health)
	SignalManager.set_boss.connect(_init_health_bar)

func _set_health(_health):
	set_health(_health)

func _init_health_bar(boss):
	current_boss = boss
	show()
	max_value = boss.max_health
	value = boss.health
	damage_bar.max_value = boss.max_health
	damage_bar.value = boss.health
