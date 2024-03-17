extends Resource
class_name ItemLegendaryStats
var stat_scales = []

func _init(data, scales):
	for i in data.size():
		stat_scales.append(StatScale.new(data[i], scales[i]))

func set_info(item_info):
	for stat_scale in stat_scales:
		stat_scale.set_info(item_info, GameEnums.RARITY.LEGENDARY)

func get_data():
	var scales = []
	for stat_scale in stat_scales:
		scales.append(stat_scale.scale)
	return scales

func get_stat(stat):
	var total = 0
	for s in stat_scales:
		total += s.get_stat(stat)
	return total
