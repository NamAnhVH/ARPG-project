extends Node

@export var player_data : PlayerData = preload("res://data/resources/player_data.tres")
@export var progress_data : ProgressData = preload("res://data/resources/progress_data.tres")

func _ready():
	SignalManager.player_name.connect(_on_player_name)
	SignalManager.change_next_progress.connect(_on_change_next_progress)
	SignalManager.update_main_quest.connect(_on_update_main_quest)
	SignalManager.accept_side_quest.connect(_on_accept_side_quest)

func _on_change_next_progress():
	var next_index = progress_data.current_story.progress.find(progress_data.current_progress) + 1
	if next_index < progress_data.current_story.progress.size():
		progress_data.current_progress = progress_data.current_story.progress[next_index]
	else:
		progress_data.current_story = ResourceManager.story_info[ResourceManager.story_info.find(progress_data.current_story) + 1]
		progress_data.current_progress = progress_data.current_story.progress[0]

func _on_player_name(player_name: String):
	player_data.player_name = player_name
	Global.player_name = player_name
	_on_change_next_progress()
	SignalManager.show_dialogue.emit(progress_data.current_story.name, progress_data.current_progress)

func _on_update_main_quest(quest: String, progress: String):
	progress_data.current_main_quest = {"id": quest, "progress": progress}

func _on_accept_side_quest(quest: String):
	progress_data.current_side_quest = quest
