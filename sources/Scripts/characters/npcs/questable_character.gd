extends NonePlayableCharacter
class_name QuestableCharacter

@export var list_quest: Array[Dictionary]

func _ready():
	SignalManager.quest_updated.connect(_on_update_main_quest)
	if check_interact():
		var quest_available = ResourceManager.get_instance("quest_available")
		quest.add_child(quest_available)

func interact():
	Global.npc_name = object_name
	if check_interact():
		SignalManager.show_dialogue.emit(StoryManager.progress_data.current_main_quest.id, StoryManager.progress_data.current_main_quest.progress)
	else:
		SignalManager.show_dialogue.emit(StoryManager.progress_data.current_main_quest.id, object_name)

func _on_update_main_quest():
	if check_interact():
		var quest_available = ResourceManager.get_instance("quest_available")
		quest.add_child(quest_available)
	elif quest.get_child_count() > 0:
			quest.get_child(0).queue_free()

func check_interact():
	for quest_id in list_quest:
		if StoryManager.progress_data.current_main_quest.has("id"):
			if StoryManager.progress_data.current_main_quest.id == quest_id.id:
				if typeof(StoryManager.progress_data.current_main_quest.progress) == typeof(quest_id.progress):
					if StoryManager.progress_data.current_main_quest.progress == quest_id.progress:
						return true
	return false

