extends InteractableChest

@export var number_of_items : int

func set_items():
	for i in number_of_items:
		chest.add_item(ItemManager.get_item(items[randi() % items.size()]))
