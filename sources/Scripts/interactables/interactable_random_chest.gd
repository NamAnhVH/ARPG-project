extends InteractableChest

@export_range(1, 10) var number_of_items : int

func set_items():
	for i in number_of_items:
		var item = ItemManager.get_item(items[randi() % items.size()])
		
		if item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
			ItemManager.generate_random_rarity(item, Global.player_level)
			
		chest.add_item(item)
