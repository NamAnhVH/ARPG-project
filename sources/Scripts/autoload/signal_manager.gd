extends Node

#Inventory
signal inventory_opened(inventory: Inventory)
signal inventory_ready(inventory: Inventory)
signal inventory_closed(inventory: Inventory)
signal equipment_opened(equipment: Equipment)
signal equipment_ready(equipment: Equipment)
signal equipment_closed(equipment: Equipment)
signal hotbar_ready(hotbar: Hotbar)
signal chest_opened(chest: Chest)
signal chest_ready(chest: Chest)
signal chest_closed(chest: Chest)

#Interactable
signal item_picked(item: Item, sender: FloorItem)
signal item_dropped(item: Item)
