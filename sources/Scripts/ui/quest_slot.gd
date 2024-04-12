extends Button
class_name QuestSlot

var quest_id : String

func _on_pressed():
	SignalManager.show_quest_description.emit(quest_id, "main_quest")
