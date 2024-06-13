extends InteractableChest

func set_items(chest: Chest):
	for i in randi_range(1, 10):
		chest.add_item(ItemManager.rng_generate_rarity(100))


