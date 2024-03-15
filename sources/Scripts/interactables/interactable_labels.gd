extends VBoxContainer

@export_node_path var lbl_action_path : NodePath
@onready var lbl_action : Label = get_node(lbl_action_path)

@export_node_path var lbl_name_path : NodePath
@onready var lbl_name : Label = get_node(lbl_name_path)

func _ready():
	hide()

func display(interactable):
	lbl_action.text = "Press 'e' to " + interactable.action
	lbl_name.text = interactable.object_name
	show()
