extends NonePlayableCharacter

func _ready():
	SignalManager.update_main_quest.connect(_on_update_main_quest)
	if StoryManager.progress_data.current_story.name == "main_quest_1" and StoryManager.progress_data.current_progress == "talk_to_villager_chief":
		var quest_available = ResourceManager.get_instance("quest_available")
		quest.add_child(quest_available)

func interact():
	Global.npc_name = object_name
	if StoryManager.progress_data.current_story.name == "main_quest_1" and StoryManager.progress_data.current_progress == "talk_to_villager_chief":
			SignalManager.show_dialogue.emit(StoryManager.progress_data.current_story.name, StoryManager.progress_data.current_progress)
	else:
		SignalManager.show_dialogue.emit(StoryManager.progress_data.current_story.name, object_name)

func _on_update_main_quest(_quest: String, progress: String):
	if _quest == "main_quest_1":
		quest.get_child(0).queue_free()
