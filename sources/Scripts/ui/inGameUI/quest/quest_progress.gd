extends VBoxContainer
class_name QuestProgress

@onready var main_quest : VBoxContainer = $MainQuest
@onready var side_quest : VBoxContainer = $SideQuest

func _ready():
	SignalManager.update_quest_progress.connect(_on_update_quest_progress)
	setup_main_quest()
	setup_side_quest()

func _on_update_quest_progress(id : String, type: GameEnums.QUEST_TYPE, finished):
	if finished: 
		if type == GameEnums.QUEST_TYPE.MAIN_QUEST:
			for quest_progress_slot : QuestProgressSlot in main_quest.get_children():
				if quest_progress_slot.quest_id == id:
					quest_progress_slot.free()
		elif type == GameEnums.QUEST_TYPE.SIDE_QUEST:
			for quest_progress_slot : QuestProgressSlot in side_quest.get_children():
				if quest_progress_slot.quest_id == id:
					quest_progress_slot.free()
	else:
		if type == GameEnums.QUEST_TYPE.MAIN_QUEST:
			update_main_quest(id)
		elif type == GameEnums.QUEST_TYPE.SIDE_QUEST:
			update_side_quest(id)

func setup_main_quest():
	if StoryManager.progress_data.current_main_quest.has("id"):
		var quest_progress_slot : QuestProgressSlot = ResourceManager.get_instance("quest_progress_slot")
		var current_quest_info = ResourceManager.quest_info["main_quest"][StoryManager.progress_data.current_main_quest.id]
		quest_progress_slot.quest_id = StoryManager.progress_data.current_main_quest.id
		quest_progress_slot.quest_name = current_quest_info.name
		quest_progress_slot.type = GameEnums.QUEST_TYPE.MAIN_QUEST
		if StoryManager.progress_data.current_main_quest.has("progress"):
			if StoryManager.progress_data.current_main_quest.progress is String:
				var text = format_string(StoryManager.progress_data.current_main_quest.progress)
				quest_progress_slot.progress = text
			elif StoryManager.progress_data.current_main_quest.progress is Dictionary:
				var text = format_string(StoryManager.progress_data.current_main_quest.progress.name)
				quest_progress_slot.progress = text
				if StoryManager.progress_data.current_main_quest.progress.has("combat"):
					quest_progress_slot.progress = quest_progress_slot.progress + " ( " + str(StoryManager.progress_data.current_main_quest_progress) + " / " + str(StoryManager.progress_data.current_main_quest.progress.combat.quantity) + " )"
		main_quest.add_child(quest_progress_slot)

func setup_side_quest():
	for quest in StoryManager.progress_data.current_side_quest:
		var quest_progress_slot : QuestProgressSlot = ResourceManager.get_instance("quest_progress_slot")
		var current_quest_info = ResourceManager.quest_info["side_quest"][quest]
		quest_progress_slot.quest_id = quest
		quest_progress_slot.quest_name = current_quest_info.name
		quest_progress_slot.type = GameEnums.QUEST_TYPE.SIDE_QUEST
		if StoryManager.progress_data.current_side_quest[quest].has("progress"):
			if StoryManager.progress_data.current_side_quest[quest].progress is String:
				var text = format_string(StoryManager.progress_data.current_side_quest[quest].progress)
				quest_progress_slot.progress = text
			elif StoryManager.progress_data.current_side_quest[quest].progress is Dictionary:
				var text = format_string(StoryManager.progress_data.current_side_quest[quest].progress.name)
				quest_progress_slot.progress = text
				if StoryManager.progress_data.current_side_quest[quest].progress.has("combat"):
					quest_progress_slot.progress = quest_progress_slot.progress + " ( " + str(StoryManager.progress_data.current_side_quest_progress[StoryManager.progress_data.current_side_quest[quest].id]) + " / " + str(StoryManager.progress_data.current_side_quest[StoryManager.progress_data.current_side_quest[quest].id].combat.quantity) + " )"
		side_quest.add_child(quest_progress_slot)

func update_main_quest(id: String):
	var is_new_quest : bool = true
	for quest_progress_slot in main_quest.get_children():
		if quest_progress_slot.quest_id == id:
			is_new_quest = false
			if StoryManager.progress_data.current_main_quest.has("progress"):
				if StoryManager.progress_data.current_main_quest.progress is String:
					var text = format_string(StoryManager.progress_data.current_main_quest.progress)
					quest_progress_slot.lbl_progress.text = text
				elif StoryManager.progress_data.current_main_quest.progress is Dictionary:
					var text = format_string(StoryManager.progress_data.current_main_quest.progress.name)
					quest_progress_slot.lbl_progress.text = text
					if StoryManager.progress_data.current_main_quest.progress.has("combat"):
						quest_progress_slot.lbl_progress.text = quest_progress_slot.lbl_progress.text + " ( " + str(StoryManager.progress_data.current_main_quest_progress) + " / " + str(StoryManager.progress_data.current_main_quest.progress.combat.quantity) + " )"
	if is_new_quest:
		setup_main_quest()



func update_side_quest(id: String):
	var is_new_quest : bool = true
	for quest_progress_slot : QuestProgressSlot in side_quest.get_children():
		if quest_progress_slot.quest_id == id:
			is_new_quest = false
			if StoryManager.progress_data.current_side_quest[id].has("progress"):
				if StoryManager.progress_data.current_side_quest[id].progress is String:
					var text = format_string(StoryManager.progress_data.current_side_quest[id].progress)
					quest_progress_slot.lbl_progress.text = text
				elif StoryManager.progress_data.current_side_quest[id].progress is Dictionary:
					var text = format_string(StoryManager.progress_data.current_side_quest[id].progress.name)
					quest_progress_slot.lbl_progress.text = text
					if StoryManager.progress_data.current_side_quest[id].progress.has("combat"):
						quest_progress_slot.lbl_progress.text = quest_progress_slot.lbl_progress.text + " ( " + str(StoryManager.progress_data.current_side_quest_progress[id]) + " / " + str(StoryManager.progress_data.current_side_quest[id].progress.combat.quantity) + " )"
			break
	if is_new_quest and StoryManager.progress_data.current_side_quest.has(id):
		var quest_progress_slot : QuestProgressSlot = ResourceManager.get_instance("quest_progress_slot")
		var current_quest_info = ResourceManager.quest_info["side_quest"][id]
		quest_progress_slot.quest_id = id
		quest_progress_slot.quest_name = current_quest_info.name
		quest_progress_slot.type = GameEnums.QUEST_TYPE.SIDE_QUEST
		if StoryManager.progress_data.current_side_quest[id].has("progress"):
			if StoryManager.progress_data.current_side_quest[id].progress is String:
				var text = format_string(StoryManager.progress_data.current_side_quest[id].progress)
				quest_progress_slot.progress = text
			elif StoryManager.progress_data.current_side_quest[id].progress is Dictionary:
				var text = format_string(StoryManager.progress_data.current_side_quest[id].progress.name)
				quest_progress_slot.progress = text
				if StoryManager.progress_data.current_side_quest[id].progress.has("combat"):
					quest_progress_slot.progress = quest_progress_slot.progress + " ( " + str(StoryManager.progress_data.current_side_quest_progress[StoryManager.progress_data.current_side_quest[id].id]) + " / " + str(StoryManager.progress_data.current_side_quest[StoryManager.progress_data.current_side_quest[id].id].combat.quantity) + " )"
		side_quest.add_child(quest_progress_slot)

func format_string(string: String):
	var result = ""
	var words = string.split("_")
	for i in range(words.size()):
		if i == words.size() - 1 and words[i].to_int() != 0 and words[i - 1] != "level":
			continue
		result += words[i]
		if i < words.size() - 1: 
			result += " "
	result = "- " + result[0].to_upper() + result.substr(1,-1)
	return result
