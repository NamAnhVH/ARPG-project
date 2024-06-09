extends CanvasLayer
class_name InGameUI

@onready var window : Control = $Window
@onready var quest_container = $Window/QuestContainer

var is_open_setting : bool = false

var setting_container

func _ready():
	SignalManager.choose_player_name.connect(_on_choose_player_name)
	SignalManager.upgrade_opened.connect(open_inventory)
	SignalManager.upgrade_closed.connect(close_inventory)
	SignalManager.shop_opened.connect(open_inventory)
	SignalManager.shop_closed.connect(close_inventory)
	SignalManager.sell_item_opened.connect(open_inventory)
	SignalManager.sell_item_closed.connect(close_inventory)

func _unhandled_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_pressed():
		if !quest_container.is_open and !Global.is_inventory_opened:
			if !is_open_setting:
				_on_setting_pressed()
			else:
				setting_container._on_close_pressed()
		else:
			if quest_container.is_open:
				quest_container.show_container()
			if Global.is_upgrade_opened:
				SignalManager.upgrade_closed.emit()
			elif Global.is_shop_opened:
				SignalManager.shop_closed.emit()
			elif Global.is_sell_item_opened:
				SignalManager.sell_item_closed.emit()
			elif Global.is_inventory_opened:
				close_inventory()
	
	if !is_open_setting:
		if event.is_action_pressed("quest"):
			quest_container.show_container()
			
		if event.is_action_pressed("inventory"):
			if !Global.is_inventory_opened:
				open_inventory()
			else:
				if Global.is_upgrade_opened:
					SignalManager.upgrade_closed.emit()
				elif Global.is_shop_opened:
					SignalManager.shop_closed.emit()
				elif Global.is_sell_item_opened:
					SignalManager.sell_item_closed.emit()
				else:
					close_inventory()

func open_inventory(para = null):
	SignalManager.inventory_opened.emit()
	Global.is_inventory_opened = true

func close_inventory():
	SignalManager.inventory_closed.emit()
	Global.is_inventory_opened = false

func _on_setting_pressed():
	is_open_setting = true
	setting_container = ResourceManager.get_instance("setting_container")
	add_child(setting_container)

func _on_choose_player_name():
	var choose_name_panel = ResourceManager.get_instance("choose_name_panel")
	window.add_child(choose_name_panel)
