extends ItemUsable
class_name ItemHealing

var healing_amount

func _init(data, parent_item):
	super(data, parent_item)
	SignalManager.player_life_changed.connect(_on_player_life_changed)
	on_use_text = "Heal %s life points"
	can_always_use = true

func set_data(data):
	healing_amount = data.healing
	super.set_data(data)

func get_use_text():
	return on_use_text % healing_amount

func _on_player_life_changed(health, max_health):
	can_use = health < health

func execute():
	SignalManager.heal_player.emit(healing_amount)
	print(healing_amount)
