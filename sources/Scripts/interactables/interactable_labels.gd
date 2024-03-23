extends VBoxContainer

@onready var lbl_action : Label = $Action
@onready var lbl_name : Label = $ObjectName

func _ready():
	hide()

func display(interactable):
	lbl_action.text = "Press 'e' to " + interactable.action
	lbl_name.text = interactable.object_name
	show()
