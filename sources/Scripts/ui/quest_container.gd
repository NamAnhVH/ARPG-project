extends TextureRect

@onready var list_quest : VBoxContainer = $ListQuestContainer/ListQuest
@onready var quest_description: VBoxContainer = $ScrollContainer/QuestDescription

var is_open: bool = false

func _ready():
	SignalManager.show_quest_description.connect(_on_show_quest_description)
	SignalManager.show_quest.connect(show_container)
	SignalManager.update_main_quest.connect(update_main_quest)
	update_main_quest()

func show_container():
	if is_open:
		hide()
	else:
		for lbl in quest_description.get_children():
			lbl.queue_free()
		show()
	is_open = !is_open

func update_main_quest(id: String = ""):
	for quest in list_quest.get_children():
		quest.queue_free()
	
	for quest_id in ResourceManager.quest_info.main_quest:
		var quest_slot : QuestSlot = ResourceManager.get_instance("quest_slot")
		quest_slot.quest_id = quest_id
		quest_slot.text = ResourceManager.quest_info.main_quest[quest_id].name
		list_quest.add_child(quest_slot)
		if !StoryManager.progress_data.current_main_quest.has("id") or StoryManager.progress_data.current_main_quest.id == quest_id:
			return

func _on_show_quest_description(id: String, type: String):
	for lbl in quest_description.get_children():
		lbl.queue_free()
	
	var quest = ResourceManager.quest_info[type][id]
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
				if StoryManager.progress_data.quest_finished.find(id) == -1:
					if !StoryManager.progress_data.current_main_quest.has("progress") or (StoryManager.progress_data.current_main_quest.progress is String and StoryManager.progress_data.current_main_quest.progress == progress):
						break
			if progress is Dictionary:
				var text = format_string(progress.name)
				lbl_progress.text = text
				if StoryManager.progress_data.current_main_quest.progress is Dictionary and StoryManager.progress_data.current_main_quest.progress == progress:
					var quantity = progress.combat.quantity if progress.has("combat") else progress.collect.quantity
					lbl_progress.text = lbl_progress.text + " ( " + str(StoryManager.progress_data.current_main_quest_progress) + " / " + str(quantity) + " )"
				quest_description.add_child(lbl_progress)
				if StoryManager.progress_data.quest_finished.find(id) == -1:
					if !StoryManager.progress_data.current_main_quest.has("progress") or (StoryManager.progress_data.current_main_quest.progress is Dictionary and StoryManager.progress_data.current_main_quest.progress.name == progress.name):
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

func format_string(string: String):
	var result = ""
	var words = string.split("_")
	for i in range(words.size()):
		if i == words.size() - 1 and words[i].to_int() != 0:
			continue
		result += words[i]
		if i < words.size() - 1: 
			result += " "
	result = "* " + result[0].to_upper() + result.substr(1,-1)
	return result
