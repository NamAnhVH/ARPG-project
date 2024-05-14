extends NinePatchRect

@export var world_data : WorldData

var current_chest: InteractableChest
var chest : Chest


func _ready():
	SignalManager.chest_opened.connect(_on_chest_opened)
	SignalManager.chest_updated.connect(_on_chest_updated)
	SignalManager.chest_closed.connect(_on_chest_closed)

func _on_chest_opened(main_chest: InteractableChest):
	current_chest = main_chest
	chest = ResourceManager.get_instance("chest")
	main_chest.set_items(chest)
	main_chest.is_open = true
	_on_chest_updated()
	add_child(chest)
	show()

func _on_chest_updated():
	world_data.chest_opened[current_chest.id] = chest.get_data()

func _on_chest_closed(main_chest: InteractableChest):
	main_chest.is_open = false
	chest.queue_free()
	hide()

