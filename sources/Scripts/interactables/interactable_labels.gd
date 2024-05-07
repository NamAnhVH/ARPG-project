extends VBoxContainer

@onready var lbl_action : Label = $Action
@onready var lbl_name : Label = $ObjectName

func _ready():
	hide()

func display(interactable):
	var interact_button = InputMap.action_get_events("interact")[0]
	lbl_action.text = "Press " + interact_button.as_text().trim_suffix(" (Physical)") + " to " + interactable.action
	lbl_name.text = interactable.object_name
	show()
