extends Node

@onready var player_data : PlayerData = preload("res://data/resources/player_data.tres")
@onready var progress_data : ProgressData = preload("res://data/resources/progress_data.tres")
@onready var world_data : WorldData = preload("res://data/resources/world_data.tres")

func _ready():
	SignalManager.player_name.connect(_on_player_name)
	SignalManager.change_next_progress.connect(_on_change_next_progress)
	SignalManager.update_main_quest.connect(_on_update_main_quest)
	SignalManager.update_side_quest.connect(_on_update_side_quest)
	SignalManager.enemy_died.connect(_on_enemy_died)
	SignalManager.open_chest.connect(_on_open_chest)
	SignalManager.level_up.connect(_on_level_up)

func _on_change_next_progress():
	if progress_data.current_story.has("progress"):
		var next_index = progress_data.current_story.progress.find(progress_data.current_progress) + 1
		if next_index < progress_data.current_story.progress.size():
			progress_data.current_progress = progress_data.current_story.progress[next_index]
	else:
		var is_stop : bool = false
		for story in ResourceManager.story_info:
			if !is_stop:
				if progress_data.current_story.name == story:
					is_stop = true
			else:
				progress_data.current_story = ResourceManager.story_info[story]
				if progress_data.current_story.has("progress"):
					progress_data.current_progress = progress_data.current_story.progress[0]
				break

func _on_player_name(player_name: String):
	player_data.player_name = player_name
	Global.player_name = player_name
	_on_change_next_progress()
	SignalManager.show_dialogue.emit(progress_data.current_story.name, progress_data.current_progress)

func _on_update_main_quest(id: String):
	var quest = ResourceManager.quest_info.main_quest[id]
	if progress_data.current_main_quest.has("id") and progress_data.current_main_quest.id == id:
		var next_progress_index = quest.progress.find(progress_data.current_main_quest.progress) + 1
		if next_progress_index < quest.progress.size():
			progress_data.current_main_quest.progress = quest.progress[next_progress_index]
			if progress_data.current_main_quest.progress is Dictionary:
				if (progress_data.current_main_quest.progress.has("level_up") and progress_data.current_main_quest.progress.level_up <= player_data.level) \
				or (progress_data.current_main_quest.progress.has("find_treasure") and world_data.chest_opened.has(progress_data.current_main_quest.progress.find_treasure)):
					_on_update_main_quest(id)
		else:
			main_quest_finished(id)
	else:
		progress_data.current_main_quest = {"id": id, "progress": quest.progress[0]}
		if progress_data.current_main_quest.progress is Dictionary:
			if (progress_data.current_main_quest.progress.has("level_up") and progress_data.current_main_quest.progress.level_up <= player_data.level) \
			or (progress_data.current_main_quest.progress.has("find_treasure") and world_data.chest_opened.has(progress_data.current_main_quest.progress.find_treasure)):
				_on_update_main_quest(id)
	SignalManager.quest_updated.emit()
	SignalManager.update_quest_progress.emit(id, GameEnums.QUEST_TYPE.MAIN_QUEST, false)

func _on_update_side_quest(id: String):
	var quest = ResourceManager.quest_info.side_quest[id]
	if progress_data.current_side_quest.has(id):
		var next_progress_index = quest.progress.find(progress_data.current_side_quest[id].progress) + 1
		if next_progress_index < quest.progress.size():
			progress_data.current_side_quest[id].progress = quest.progress[next_progress_index]
			if progress_data.current_side_quest[id].progress is Dictionary:
				if (progress_data.current_side_quest[id].progress.has("level_up") and progress_data.current_side_quest[id].progress.level_up <= player_data.level) \
				or (progress_data.current_side_quest[id].progress.has("find_treasure") and world_data.chest_opened.has(progress_data.current_side_quest[id].progress.find_treasure)):
					_on_update_side_quest(id)
		else:
			side_quest_finished(id)
	else:
		progress_data.current_side_quest.merge({id: {"progress": quest.progress[0]}})
	SignalManager.quest_updated.emit()
	SignalManager.update_quest_progress.emit(id, GameEnums.QUEST_TYPE.SIDE_QUEST, false)

func _on_enemy_died(enemy):
	if progress_data.current_main_quest.progress is Dictionary \
	and progress_data.current_main_quest.progress.has("combat"):
		if check_enemy(enemy):
			progress_data.current_main_quest_progress += 1
			SignalManager.update_quest_progress.emit(progress_data.current_main_quest.id, GameEnums.QUEST_TYPE.MAIN_QUEST, false)
			if progress_data.current_main_quest_progress >= progress_data.current_main_quest.progress.combat.quantity:
				progress_data.current_main_quest_progress = 0
				_on_update_main_quest(progress_data.current_main_quest.id)
			
	for side_quest in progress_data.current_side_quest:
		if progress_data.current_side_quest[side_quest].progress is Dictionary \
		and progress_data.current_side_quest[side_quest].progress.has("combat"):
			if check_enemy(enemy, side_quest):
				if progress_data.current_side_quest_progress.has(side_quest):
					progress_data.current_side_quest_progress[side_quest] += 1
				else:
					progress_data.current_side_quest_progress.merge({side_quest: 1})
				SignalManager.update_quest_progress.emit(side_quest, GameEnums.QUEST_TYPE.SIDE_QUEST, false)
				if progress_data.current_side_quest_progress[side_quest] >= progress_data.current_side_quest[side_quest].progress.combat.quantity:
					progress_data.current_side_quest_progress.erase(side_quest)
					_on_update_side_quest(side_quest)

func check_enemy(enemy, quest = ""):
	if quest.is_empty():
		if enemy is Slime and progress_data.current_main_quest.progress.combat.enemy == "slime" \
		and progress_data.current_main_quest.progress.combat.min_level <= enemy.level \
		and progress_data.current_main_quest.progress.combat.max_level >= enemy.level:
			return true
		elif enemy is Gremlin and progress_data.current_main_quest.progress.combat.enemy == "gremlin" \
		and progress_data.current_main_quest.progress.combat.min_level <= enemy.level \
		and progress_data.current_main_quest.progress.combat.max_level >= enemy.level :
			return true
		elif enemy is Mushroom and progress_data.current_main_quest.progress.combat.enemy == "mushroom" \
		and progress_data.current_main_quest.progress.combat.min_level <= enemy.level \
		and progress_data.current_main_quest.progress.combat.max_level >= enemy.level :
			return true
	else:
		if enemy is Slime and progress_data.current_side_quest[quest].progress.combat.enemy == "slime" \
		and progress_data.current_side_quest[quest].progress.combat.min_level <= enemy.level \
		and progress_data.current_side_quest[quest].progress.combat.max_level >= enemy.level:
			return true
		elif enemy is Gremlin and progress_data.current_side_quest[quest].progress.combat.enemy == "gremlin" \
		and progress_data.current_side_quest[quest].progress.combat.min_level <= enemy.level \
		and progress_data.current_side_quest[quest].progress.combat.max_level >= enemy.level:
			return true
		elif enemy is Mushroom and progress_data.current_side_quest[quest].progress.combat.enemy == "mushroom" \
		and progress_data.current_side_quest[quest].progress.combat.min_level <= enemy.level \
		and progress_data.current_side_quest[quest].progress.combat.max_level >= enemy.level:
			return true
	return false

func _on_level_up():
	if progress_data.current_main_quest.progress is Dictionary \
	and progress_data.current_main_quest.progress.has("level_up") \
	and progress_data.current_main_quest.progress.level_up <= player_data.level:
		_on_update_main_quest(progress_data.current_main_quest.id)
	for side_quest in progress_data.current_side_quest:
		if progress_data.current_side_quest[side_quest].progress is Dictionary \
		and progress_data.current_side_quest[side_quest].has("level_up") \
		and progress_data.current_side_quest[side_quest].progress.level_up <= player_data.level:
			_on_update_side_quest(side_quest)

func _on_open_chest(chest: InteractableChest):
	if world_data.chest_opened.has(chest.id):
		world_data.chest_opened.merge({chest.id: {}})
	if progress_data.current_main_quest.progress is Dictionary \
	and progress_data.current_main_quest.progress.has("find_treasure") \
	and progress_data.current_main_quest.progress.find_treasure == chest.id:
		_on_update_main_quest(progress_data.current_main_quest.id)
	for side_quest in progress_data.current_side_quest:
		if progress_data.current_side_quest[side_quest].progress is Dictionary \
		and progress_data.current_side_quest[side_quest].progress.has("find_treasure") \
		and progress_data.current_side_quest[side_quest].progress.find_treasure == chest.id:
			_on_update_side_quest(side_quest)

func main_quest_finished(id: String):
	var quest = ResourceManager.quest_info.main_quest[id]
	if quest.reward.has("money"):
		SignalManager.gain_money.emit(quest.reward.money)
	if quest.reward.has("exp"):
		SignalManager.gain_exp.emit(quest.reward.exp) 
	progress_data.main_quest_finished.append(id)
	if quest.has("active_side_quest"):
		for quest_id in quest.active_side_quest:
			_on_update_side_quest(quest_id)
	var next_main_quest_id
	var stop = false
	for quest_id in ResourceManager.quest_info.main_quest:
		if !stop:
			if quest_id == id:
				stop = true
		else:
			next_main_quest_id = quest_id
			break
	SignalManager.update_quest_progress.emit(id, GameEnums.QUEST_TYPE.MAIN_QUEST, true)
	_on_update_main_quest(next_main_quest_id)

func side_quest_finished(id: String):
	var quest = ResourceManager.quest_info.side_quest[id]
	if quest.reward.has("money"):
		SignalManager.gain_money.emit(quest.reward.money)
	if quest.reward.has("exp"):
		SignalManager.gain_exp.emit(quest.reward.exp) 
	progress_data.side_quest_finished.append(id)
	progress_data.current_side_quest.erase(id)
	SignalManager.update_quest_progress.emit(id, GameEnums.QUEST_TYPE.SIDE_QUEST, true)

