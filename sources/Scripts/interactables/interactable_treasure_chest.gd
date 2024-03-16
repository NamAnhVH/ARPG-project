extends InteractableChest

func set_item():
	pass

func interact():
	for s in chest.slots:
		s.put_item(ItemManager.rng_generate_rarity(100))
	
	SignalManager.chest_opened.emit(chest)
