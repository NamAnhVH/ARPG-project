extends AnimatedSprite2D
class_name QuestAvailable

var quest_type : GameEnums.QUEST_TYPE

func _ready():
	if quest_type == GameEnums.QUEST_TYPE.MAIN_QUEST:
		play("main_quest")
	else:
		play("side_quest")
