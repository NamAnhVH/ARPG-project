extends CanvasLayer

@onready var window : Control = $Window
@onready var quest_container = $Window/QuestContainer

var is_open_inventory : bool = false
var is_open_setting : bool = false

var setting_container

func _ready():
	SignalManager.choose_player_name.connect(_on_choose_player_name)

func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_pressed():
		if !quest_container.is_open and !is_open_inventory:
			if !is_open_setting:
				_on_setting_pressed()
			else:
				setting_container._on_close_pressed()
		else:
			if quest_container.is_open:
				quest_container.show_container()
			if is_open_inventory:
				SignalManager.inventory_closed.emit()
				is_open_inventory = false
	
	if !is_open_setting:
		if event.is_action_pressed("quest"):
			quest_container.show_container()
			
		if event.is_action_pressed("inventory"):
			if !is_open_inventory:
				SignalManager.inventory_opened.emit()
				is_open_inventory = true
			else:
				SignalManager.inventory_closed.emit()
				is_open_inventory = false

func _on_setting_pressed():
	is_open_setting = true
	setting_container = ResourceManager.get_instance("setting_container")
	add_child(setting_container)

func _on_choose_player_name():
	var choose_name_panel = ResourceManager.get_instance("choose_name_panel")
	window.add_child(choose_name_panel)
