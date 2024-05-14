extends NinePatchRect
class_name FileSavingContainer

@onready var v_box_container : VBoxContainer = $ScrollContainer/VBoxContainer
@onready var list_file_save : VBoxContainer = $ScrollContainer/VBoxContainer/ListFileSave

var is_save_game : bool = true
var list_file_save_name : Array[String]

func _ready():
	SignalManager.update_file_saving_container.connect(_on_update_file_saving_container)
	if is_save_game:
		var add_file_save_button = ResourceManager.get_instance("add_file_save_button")
		v_box_container.add_child(add_file_save_button)
	
	list_file_save_name = SaveManager.get_list_file_save()
	
	for file_name in list_file_save_name:
		var save_slot : SaveSlot = ResourceManager.get_instance("save_slot")
		save_slot.file_name = file_name
		save_slot.is_save_game = is_save_game
		list_file_save.add_child(save_slot)

func _on_update_file_saving_container():
	var list_file_save_name_updated = SaveManager.get_list_file_save()
	
	for file_name in list_file_save_name_updated:
		if list_file_save_name.find(file_name) == -1:
			var save_slot : SaveSlot = ResourceManager.get_instance("save_slot")
			save_slot.is_save_game = true
			save_slot.file_name = file_name
			list_file_save.add_child(save_slot)
			list_file_save_name.append(file_name)

func _on_close_pressed():
	SignalManager.close_file_saving_container.emit()
	queue_free()

