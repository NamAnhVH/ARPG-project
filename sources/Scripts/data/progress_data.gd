extends Resource
class_name ProgressData

@export var current_story: Dictionary
@export var current_progress : String
@export var current_main_quest: Dictionary
@export var current_side_quest: String
@export var current_main_quest_progress : int
@export var current_side_quest_progress : int

var quest_finished = []

func set_data(data):
	current_story = data.current_story
	current_progress = data.current_progress
	current_main_quest = data.current_main_quest
	current_side_quest = data.current_side_quest
	current_main_quest_progress = data.current_main_quest_progress
	current_side_quest_progress = data.current_side_quest_progress
	quest_finished = data.quest_finished
	emit_changed()

func get_data():
	return {
		"current_story": current_story,
		"current_progress": current_progress,
		"current_main_quest": current_main_quest,
		"current_side_quest": current_side_quest,
		"current_main_quest_progress": current_main_quest_progress,
		"current_side_quest_progress": current_side_quest_progress,
		"quest_finished": quest_finished
	}


