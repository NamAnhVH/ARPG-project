extends VBoxContainer
class_name QuestProgressSlot

@onready var lbl_name : Label = $Name
@onready var lbl_progress : Label = $Progress

var quest_id : String
var quest_name : String
var progress : String
var type : GameEnums.QUEST_TYPE

func _ready():
	lbl_name.text = quest_name
	lbl_progress.text = progress
	if type == GameEnums.QUEST_TYPE.MAIN_QUEST:
		lbl_name.label_settings.font_color = Color("EFA51B")
		lbl_progress.label_settings.font_color = Color("EFA51B")
	else:
		lbl_name.label_settings.font_color = Color("1A49F0")
		lbl_progress.label_settings.font_color = Color("1A49F0")
