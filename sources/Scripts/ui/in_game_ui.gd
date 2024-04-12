extends CanvasLayer

@onready var window : Control = $Window

var is_open_inventory : bool = false

func _ready():
	SignalManager.choose_player_name.connect(_on_choose_player_name)

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if !is_open_inventory:
			SignalManager.inventory_opened.emit()
			is_open_inventory = true
			window.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			SignalManager.inventory_closed.emit()
			is_open_inventory = false
			window.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_setting_pressed():
	var setting_container = ResourceManager.get_instance("setting_container")
	add_child(setting_container)

func _on_choose_player_name():
	var choose_name_panel = ResourceManager.get_instance("choose_name_panel")
	window.add_child(choose_name_panel)
