extends Node
class_name StatScale

var stat_range : StatRange
var scale : float

func _init(data, value):
	stat_range = StatRange.new(data)
	scale = value

func set_info(item_info, color_id):
	var display = ResourceManager.stat_info[stat_range.stat].display
	var value = stat_range.get_value(scale, stat_range.stat)
	var text = display % str(value)
	item_info.add_line(ItemInfoLine.new(text, ResourceManager.colors[color_id]))
