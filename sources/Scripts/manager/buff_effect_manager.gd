extends Node

func _ready():
	SignalManager.buff_player.connect(_on_buff_player)

func _on_buff_player(amount, type, effective_time):
	var buff_slot : BuffSlot = ResourceManager.get_instance("buff_slot")
	buff_slot.type = type
	buff_slot.amount = amount
	buff_slot.effective_time = effective_time
	add_child(buff_slot)

func get_stat(stat):
	var total = 0
	for buff in get_children():
		if (buff.type == "buff_atk" and stat == GameEnums.STAT.ATK) \
		or (buff.type == "buff_def" and stat == GameEnums.STAT.DEF) \
		or (buff.type == "buff_crit_rate" and stat == GameEnums.STAT.CRIT_RATE) \
		or (buff.type == "buff_crit_damage" and stat == GameEnums.STAT.CRIT_DAMAGE) \
		or (buff.type == "buff_move_speed" and stat == GameEnums.STAT.MOVE_SPEED):
			total += buff.amount
	return total

func _on_child_order_changed():
	SignalManager.update_stat.emit()
