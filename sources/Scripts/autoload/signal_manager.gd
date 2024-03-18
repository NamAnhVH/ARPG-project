extends Node

#Inventory
signal inventory_opened()
signal inventory_ready()
signal inventory_closed()
signal get_inventory_data()
signal set_inventory_data(inventory: Inventory)
signal equipment_ready()
signal get_equipment_data()
signal set_equipment_data(equipment: Equipment)
signal hotbar_ready(hotbar: Hotbar)
signal chest_opened(chest: Chest)
signal chest_ready(chest: Chest)
signal chest_closed(chest: Chest)
signal content_changed()

#Interactable
signal item_dropped(item: Item)

#PlayableCharacter
signal player_life_changed(health, max_health)
signal heal_player(healing_amount)
signal equip_item(item)
signal unequip_item(equipment_type)

#Item
signal upgrade_item()
signal has_upgradable_item(value)

#SaveManager
signal saving_game()
