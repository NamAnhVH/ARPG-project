extends TextureRect

@onready var list_quest : VBoxContainer = $ListQuestContainer/ListQuest
@onready var quest_description: VBoxContainer = $ScrollContainer/QuestDescription

var is_open: bool = false

func _ready():
	SignalManager.show_quest_description.connect(_on_show_quest_description)
	SignalManager.show_quest.connect(show_container)

func show_container():
	if is_open:
		for quest in list_quest.get_children():
			quest.queue_free()
		hide()
	else:
		for lbl in quest_description.get_children():
			lbl.queue_free()
		show_main_quest()
		show()
	is_open = !is_open

func show_main_quest():
	for quest in list_quest.get_children():
		quest.queue_free()
	
	for quest_id in ResourceManager.quest_info.main_quest:
		var quest_slot : QuestSlot = ResourceManager.get_instance("quest_slot")
		quest_slot.quest_id = quest_id
		quest_slot.type_quest = "main_quest"
		quest_slot.text = ResourceManager.quest_info.main_quest[quest_id].name
		list_quest.add_child(quest_slot)
		if !StoryManager.progress_data.current_main_quest.has("id") or StoryManager.progress_data.current_main_quest.id == quest_id:
			return

func show_side_quest():
	for quest in list_quest.get_children():
		quest.queue_free()
	
	for main_quest_id_finished in StoryManager.progress_data.main_quest_finished:
		if ResourceManager.quest_info.main_quest[main_quest_id_finished].has("active_side_quest"):
			for side_quest in ResourceManager.quest_info.main_quest[main_quest_id_finished].active_side_quest:
				var quest_slot : QuestSlot = ResourceManager.get_instance("quest_slot")
				quest_slot.quest_id = side_quest
				quest_slot.type_quest = "side_quest"
				quest_slot.text = ResourceManager.quest_info.side_quest[side_quest].name
				list_quest.add_child(quest_slot)

func _on_show_quest_description(id: String, type: String):
	for lbl in quest_description.get_children():
		lbl.queue_free()
	
	var quest = ResourceManager.quest_info[type][id]
	var quest_name = ResourceManager.get_instance("quest_name")
	quest_name.text = quest.name
	quest_description.add_child(quest_name)
	if quest.has("description"):
		var description = ResourceManager.get_instance("quest_description")
		description.text = quest.description
		quest_description.add_child(description)
	if quest.has("progress"):
		var is_stop: bool = false
		for progress in quest.progress:
			var lbl_progress = ResourceManager.get_instance("quest_description")
			if progress is String:
				var text = format_string(progress)
				lbl_progress.text = text
				quest_description.add_child(lbl_progress)
				if type == "main_quest" \
				and StoryManager.progress_data.main_quest_finished.find(id) == -1:
					if !StoryManager.progress_data.current_main_quest.has("progress") \
					or (StoryManager.progress_data.current_main_quest.progress is String \
					and StoryManager.progress_data.current_main_quest.progress == progress):
						break
				elif type == "side_quest" \
				and StoryManager.progress_data.side_quest_finished.find(id) == -1:
					if !StoryManager.progress_data.current_side_quest[id].has("progress") \
					or (StoryManager.progress_data.current_side_quest[id].progress is String \
					and StoryManager.progress_data.current_side_quest[id].progress == progress):
						break
			elif progress is Dictionary:
				var text = format_string(progress.name)
				lbl_progress.text = text
				if type == "main_quest":
					if StoryManager.progress_data.current_main_quest.progress is Dictionary \
					and StoryManager.progress_data.current_main_quest.progress == progress \
					and progress.has("combat"):
						lbl_progress.text = lbl_progress.text + " ( " + str(StoryManager.progress_data.current_main_quest_progress) + " / " + str(progress.combat.quantity) + " )"
					quest_description.add_child(lbl_progress)
					if StoryManager.progress_data.main_quest_finished.find(id) == -1:
						if !StoryManager.progress_data.current_main_quest.has("progress") \
						or (StoryManager.progress_data.current_main_quest.progress is Dictionary \
						and StoryManager.progress_data.current_main_quest.progress.name == progress.name):
							break
				elif type == "side_quest":
					if StoryManager.progress_data.current_side_quest.has(id) \
					and StoryManager.progress_data.current_side_quest[id].progress is Dictionary \
					and StoryManager.progress_data.current_side_quest[id].progress == progress \
					and progress.has("combat"):
						lbl_progress.text = lbl_progress.text + " ( " + str(StoryManager.progress_data.current_side_quest_progress) + " / " + str(progress.combat.quantity) + " )"
					quest_description.add_child(lbl_progress)
					if StoryManager.progress_data.side_quest_finished.find(id) == -1:
						if !StoryManager.progress_data.current_side_quest.has("progress") \
						or (StoryManager.progress_data.current_side_quest.progress is Dictionary \
						and StoryManager.progress_data.current_side_quest.progress.name == progress.name):
							break
	
	if quest.has("reward"):
		if quest.reward.has("money"):
			var money = ResourceManager.get_instance("quest_description")
			money.text = "money: +" + str(quest.reward.money)
			quest_description.add_child(money)
		if quest.reward.has("exp"):
			var experience = ResourceManager.get_instance("quest_description")
			experience.text = "exp: +" + str(quest.reward.exp)
			quest_description.add_child(experience)
	
	if StoryManager.progress_data.main_quest_finished.find(id) != -1:
		var finished = ResourceManager.get_instance("quest_description")
		finished.text = "Quest finished"
		quest_description.add_child(finished)
	if StoryManager.progress_data.side_quest_finished.find(id) != -1:
		var finished = ResourceManager.get_instance("quest_description")
		finished.text = "Quest finished"
		quest_description.add_child(finished)

func format_string(string: String):
	var result = ""
	var words = string.split("_")
	for i in range(words.size()):
		if i == words.size() - 1 and words[i].to_int() != 0 and words[i - 1] != "level":
			continue
		result += words[i]
		if i < words.size() - 1: 
			result += " "
	result = "* " + result[0].to_upper() + result.substr(1,-1)
	return result

func _on_main_quest_pressed():
	show_main_quest()

func _on_side_quest_pressed():
	show_side_quest()
