extends Node

@export var player_data : PlayerData = preload("res://data/resources/player_data.tres")
@export var progress_data : ProgressData = preload("res://data/resources/progress_data.tres")

func _ready():
	SignalManager.player_name.connect(_on_player_name)
	SignalManager.change_next_progress.connect(_on_change_next_progress)
	SignalManager.update_main_quest.connect(_on_update_main_quest)
	SignalManager.accept_side_quest.connect(_on_accept_side_quest)
	SignalManager.enemy_died.connect(_on_enemy_died)

func _on_change_next_progress():
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
		else:
			main_quest_finished(id)
	else:
		progress_data.current_main_quest = {"id": id, "progress": quest.progress[0]}
	SignalManager.quest_updated.emit()

func _on_accept_side_quest(quest: String):
	progress_data.current_side_quest = quest

func _on_enemy_died(enemy):
	if progress_data.current_main_quest.progress is Dictionary and progress_data.current_main_quest.progress.has("combat"):
		if check_enemy_type(enemy):
			progress_data.current_main_quest_progress += 1
			if progress_data.current_main_quest_progress >= progress_data.current_main_quest.progress.combat.quantity:
				_on_update_main_quest(progress_data.current_main_quest.id)

func check_enemy_type(enemy):
	if enemy is SlimeCharacter and progress_data.current_main_quest.progress.combat.enemy == "slime":
		return true
	return false

func main_quest_finished(id: String):
	var quest = ResourceManager.quest_info.main_quest[id]
	if quest.reward.has("money"):
		SignalManager.gain_money.emit(quest.reward.money)
	if quest.reward.has("exp"):
		SignalManager.gain_exp.emit(quest.reward.exp) 
	progress_data.quest_finished.append(id)
	var next_main_quest_id
	var stop = false
	for quest_id in ResourceManager.quest_info.main_quest:
		if !stop:
			if quest_id == id:
				stop = true
		else:
			next_main_quest_id = quest_id
			break
	_on_update_main_quest(next_main_quest_id)
