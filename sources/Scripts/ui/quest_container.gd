extends TextureRect

@onready var list_quest : VBoxContainer = $ListQuestContainer/ListQuest
@onready var quest_description: VBoxContainer = $ScrollContainer/QuestDescription

var is_open: bool = false

func _ready():
	SignalManager.show_quest_description.connect(_on_show_quest_description)
	SignalManager.show_quest.connect(show_container)
	SignalManager.update_main_quest.connect(update_quest)
	update_quest()

func show_container():
	if is_open:
		hide()
	else:
		for lbl in quest_description.get_children():
			lbl.queue_free()
		show()
	is_open = !is_open

func update_quest(id: String = "", progress: String = ""):
	for quest in list_quest.get_children():
		quest.queue_free()
	
	for quest in ResourceManager.quest_info.main_quest:
		var quest_slot : QuestSlot = ResourceManager.get_instance("quest_slot")
		quest_slot.quest_id = quest.id
		quest_slot.text = quest.name
		list_quest.add_child(quest_slot)
		if !StoryManager.progress_data.current_main_quest.has("id") or StoryManager.progress_data.current_main_quest.id == quest.id:
			return

func _on_show_quest_description(id: String, type: String):
	for lbl in quest_description.get_children():
		lbl.queue_free()
	
	for quest in ResourceManager.quest_info[type]:
		if id == quest.id:
			if quest.has("description"):
				var description = ResourceManager.get_instance("quest_description")
				description.text = quest.description
				quest_description.add_child(description)
			if quest.has("progress"):
				var is_stop: bool = false
				for progress: String in quest.progress:
					var lbl_progress = ResourceManager.get_instance("quest_description")
					progress = progress.replace("_", " ")
					lbl_progress.text = "* " + progress[0].to_upper() + progress.substr(1,-1)
					quest_description.add_child(lbl_progress)
					if !StoryManager.progress_data.current_main_quest.has("progress") or StoryManager.progress_data.current_main_quest.progress == progress:
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
