extends ItemUsable
class_name Buff

var effective_time

func _init(data, parent_item, buff_type):
	super(data, parent_item, buff_type)
	can_always_use = true

func set_data(data):
	super.set_data(data)
	effective_time = data.effective_time
	set_on_use_text()

func get_use_text():
	return on_use_text % amount

func execute():
	SignalManager.buff_player.emit(amount, type, effective_time)

func set_on_use_text():
	match type:
		"buff_atk":
			on_use_text = "Add %s atk points"
		"buff_def":
			on_use_text = "Add %s def points"
		"buff_crit_rate":
			on_use_text = "Add %s%% crit rate"
		"buff_crit_damage":
			on_use_text = "Add %s%% crit damage"
		"buff_move_speed":
			on_use_text = "Add %s%% move speed"
