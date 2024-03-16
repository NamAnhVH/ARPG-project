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
