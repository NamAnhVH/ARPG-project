extends Resource
class_name ProgressData

@export var current_story: String
@export var current_main_quest: String
@export var current_side_quest: String

func _ready():
	SignalManager.change_next_story.connect(_on_change_next_story)

func set_data(data):
	current_story = data.current_story if data.current_story else ResourceManager.story_info[0]
	current_main_quest = data.current_main_quest if data.current_main_quest else ""
	current_side_quest = data.current_side_quest if data.current_side_quest else ""
	emit_changed()

func get_data():
	return {
		"current_story": current_story,
		"current_main_quest": current_main_quest,
		"current_side_quest": current_side_quest
	}

func _on_change_next_story():
	current_story = ResourceManager.story_info[ResourceManager.story_info.find(current_story) + 1]
