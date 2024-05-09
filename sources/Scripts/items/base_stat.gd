extends Resource
class_name BaseStat

var stats = []
var item_rarity

func _init(data, rarity = GameEnums.RARITY.COMMON):
	for stat in data:
		var value = stat.value if stat.has("value") else randi_range(stat.minimum, stat.maximum)
		stats.append({"stat": stat.stat, "value": value})
	item_rarity = rarity

func add_affixes(affixes, rarity):
	item_rarity = rarity
	for affix in affixes:
		var is_stat_existed: bool = false
		for stat in stats:
			if stat.stat == affix.stat:
				is_stat_existed = true
				stat.value += affix.value
				break
		if !is_stat_existed: stats.append(affix)

func upgrade():
	var stat_upgrade_index = randi_range(0, stats.size() - 1)
	match GameEnums.STAT[stats[stat_upgrade_index].stat]:
		GameEnums.STAT.ATK or GameEnums.STAT.DEF or GameEnums.STAT.CRIT_DAMAGE or GameEnums.STAT.MOVE_SPEED:
			stats[stat_upgrade_index].value += 2
		GameEnums.STAT.CRIT_RATE:
			stats[stat_upgrade_index].value += 1
		GameEnums.STAT.LIFE_POINT:
			stats[stat_upgrade_index].value += 5
		GameEnums.STAT.BONUS_EXPERIENCE:
			stats[stat_upgrade_index].value += 3

func set_info(item_info):
	for stat in stats:
		var text = ResourceManager.stat_info[GameEnums.STAT[stat.stat]].display % stat.value
		item_info.add_line(ItemInfoLine.new(text, item_rarity))

func get_stat(stat_type):
	var total = 0
	for stat in stats:
		if GameEnums.STAT[stat.stat] == stat_type:
			total += stat.value
	return total

func get_data():
	return stats
