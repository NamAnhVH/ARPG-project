extends ItemUsable

func _init(data, parent_item, usable_type = "healing"):
	super(data, parent_item, usable_type)
	SignalManager.player_life_changed.connect(_on_player_life_changed)
	on_use_text = "Heal %s life points"
	can_always_use = true

func get_use_text():
	return on_use_text % amount

func _on_player_life_changed(health, max_health):
	can_use = health < health

func execute():
	SignalManager.heal_player.emit(-amount)

func get_can_use():
		return (can_use or can_always_use) and item.item_slot and item.item_slot.is_on_player
