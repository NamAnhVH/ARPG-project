extends NonePlayableCharacter
class_name QuestableCharacter

@export var list_quest: Array[Dictionary]

func _ready():
	SignalManager.quest_updated.connect(_on_update_quest)
	var quest_interact = check_interact()
	if quest_interact:
		var quest_available : QuestAvailable = ResourceManager.get_instance("quest_available")
		if quest_interact is GameEnums.QUEST_TYPE \
		and quest_interact == GameEnums.QUEST_TYPE.MAIN_QUEST:
			quest_available.quest_type = quest_interact
		else:
			quest_available.quest_type = GameEnums.QUEST_TYPE.SIDE_QUEST
		quest_icon.add_child(quest_available)

func interact():
	Global.npc_name = object_name
	var quest_interact = check_interact()
	if quest_interact:
		if quest_interact is GameEnums.QUEST_TYPE \
		and quest_interact == GameEnums.QUEST_TYPE.MAIN_QUEST:
			SignalManager.show_dialogue.emit(StoryManager.progress_data.current_main_quest.id, StoryManager.progress_data.current_main_quest.progress)
		else:
			SignalManager.show_dialogue.emit(quest_interact, StoryManager.progress_data.current_side_quest[quest_interact].progress)
	else:
		SignalManager.show_dialogue.emit(StoryManager.progress_data.current_main_quest.id, object_name)

func _on_update_quest():
	var quest_interact = check_interact()
	if quest_interact:
		var quest_available : QuestAvailable = ResourceManager.get_instance("quest_available")
		if quest_interact == GameEnums.QUEST_TYPE.MAIN_QUEST:
			quest_available.quest_type = quest_interact
		else:
			quest_available.quest_type = GameEnums.QUEST_TYPE.SIDE_QUEST
		if quest_icon.get_child_count() > 0:
			for i in quest_icon.get_children():
				i.queue_free()
		quest_icon.add_child(quest_available)
	elif quest_icon.get_child_count() > 0:
		for i in quest_icon.get_children():
			i.queue_free()

func check_interact():
	for quest in list_quest:
		if StoryManager.progress_data.current_main_quest.has("id") \
		and StoryManager.progress_data.current_main_quest.id == quest.id \
		and typeof(StoryManager.progress_data.current_main_quest.progress) == typeof(quest.progress) \
		and StoryManager.progress_data.current_main_quest.progress == quest.progress:
			return GameEnums.QUEST_TYPE.MAIN_QUEST
		elif StoryManager.progress_data.current_side_quest.has(quest.id) \
		and typeof(StoryManager.progress_data.current_side_quest[quest.id].progress) == typeof(quest.progress) \
		and StoryManager.progress_data.current_side_quest[quest.id].progress == quest.progress:
			return quest.id
	return null

