extends Resource
class_name BaseStat

var stat_ranges = []
var scale : float = 0

func _init(data):
	for stat_range in data:
		stat_ranges.append(StatRange.new(stat_range))

func set_info(item_info):
	for stat_range in stat_ranges:
		var display = ResourceManager.stat_info[stat_range.stat].display
		var value = stat_range.get_value(scale, stat_range.stat)
		var text = display % value
		item_info.add_line(ItemInfoLine.new(text, ResourceManager.colors[GameEnums.RARITY.COMMON]))

func get_data():
	return scale

func get_stat(stat):
	var total = 0
	for stat_range in stat_ranges:
		total += stat_range.get_value(scale, stat)
	return total
