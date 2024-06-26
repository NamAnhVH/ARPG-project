extends NinePatchRect

@onready var action_list : VBoxContainer = $TabContainer/Controls/InputSetting/ScrollContainer/ActionList
@onready var background_music_sprite : AnimatedSprite2D = $TabContainer/Sound/SoundSetting/HBoxContainer/BackgroundMusicSprite
@onready var sound_effect_sprite : AnimatedSprite2D = $TabContainer/Sound/SoundSetting/HBoxContainer2/SoundEffectSprite
@onready var fullscreen_button : Button = $TabContainer/Graphics/GraphicSetting/HBoxContainer/FullScreenButton
@onready var vsync_button : Button = $TabContainer/Graphics/GraphicSetting/HBoxContainer2/VsyncButton
@onready var tab_container : TabContainer = $TabContainer

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var is_remapping : bool = false
var action_to_remap
var remapping_button
var is_start_game_screen : bool = false

var input_actions = {
	"move_up": "Move up",
	"move_left": "Move left",
	"move_down": "Move down",
	"move_right": "Move right",
	"interact": "Interact",
	"attack": "Attack",
	"dodge": "Dodge",
	"parry": "Parry",
	"inventory": "Inventory",
	"draw_sheath": "Draw Sheath",
	"hotbar_1": "Hot bar 1",
	"hotbar_2": "Hot bar 2",
	"hotbar_3": "Hot bar 3",
	"hotbar_4": "Hot bar 4",
	"hotbar_5": "Hot bar 5",
	"quest": "Quest"
}

func _ready():
	check_screen()
	set_graphic_setting_container()
	set_sound_setting_container()
	SignalManager.close_file_saving_container.connect(_on_close_file_saving_container)
	create_action_list()

func check_screen():
	if is_start_game_screen:
		tab_container.set_tab_disabled(3, true)

func set_graphic_setting_container():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_button.button_pressed = true
	else:
		fullscreen_button.button_pressed = false
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		vsync_button.button_pressed = true
	else:
		vsync_button.button_pressed = false

func set_sound_setting_container():
	if AudioServer.is_bus_mute(MUSIC_BUS_ID):
		background_music_sprite.play("muted")
	else:
		background_music_sprite.play("unmuted")
	if AudioServer.is_bus_mute(SFX_BUS_ID):
		sound_effect_sprite.play("muted")
	else:
		sound_effect_sprite.play("unmuted")

func create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = ResourceManager.get_instance("input_button")
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("InputLabel")
		
		action_label.text = action
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("InputLabel").text = "Press key to bind..."

func _input(event):
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func update_action_list(button, event):
	button.find_child("InputLabel").text = event.as_text().trim_suffix(" (Physical)")

func _on_close_file_saving_container():
	for i in get_children():
		i.mouse_filter = MOUSE_FILTER_STOP

func _on_button_save_load_pressed(is_save_game: bool):
	for i in get_children():
		i.mouse_filter = MOUSE_FILTER_IGNORE
	var file_saving_container : FileSavingContainer = ResourceManager.get_instance("file_saving_container")
	file_saving_container.is_save_game = is_save_game
	add_child(file_saving_container)

func _on_save_game_pressed():
	_on_button_save_load_pressed(true)

func _on_load_game_pressed():
	_on_button_save_load_pressed(false)

func _on_close_pressed():
	if get_parent() is InGameUI: get_parent().is_open_setting = false
	queue_free()

func _on_quit_game_pressed():
	get_tree().change_scene_to_file("res://sources/scenes/entities/gameSetup/start_game.tscn")

func _on_reset_button_pressed():
	create_action_list()

func _on_full_screen_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vsync_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_background_button_pressed():
	if background_music_sprite.animation == "muted":
		background_music_sprite.play("unmuted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
	elif background_music_sprite.animation == "unmuted":
		background_music_sprite.play("muted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, true)

func _on_sound_effect_button_pressed():
	if sound_effect_sprite.animation == "muted":
		sound_effect_sprite.play("unmuted")
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
	elif sound_effect_sprite.animation == "unmuted":
		sound_effect_sprite.play("muted")
		AudioServer.set_bus_mute(SFX_BUS_ID, true)
