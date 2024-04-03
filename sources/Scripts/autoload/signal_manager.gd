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

#Shop
signal set_shop(npc_name: String)
signal shop_opened(list_item : Array[ShopItem])
signal shop_closed()
signal shop_ready(shop: Shop)
signal buy_item(price: int)

#Interactable
signal item_dropped(item: Item)

#PlayableCharacter
signal player_life_changed(health, max_health)
signal heal_player(healing_amount)
signal equip_item(item)
signal unequip_item(equipment_type)
signal gain_money(value: int)
signal gain_exp(value: int)
signal level_up()

#ProgressBar
signal set_health_bar(max_health, health)
signal new_max_health(value)
signal new_health(value)

#Item
signal upgrade_item()
signal has_upgradable_item(value)

#Map
signal change_map(map_id: String)
signal change_world(map_id: String, location: Vector2)
signal set_player()
signal clear_hidden_node()

#SaveManager
signal saving_game()

#Change scene
signal scene_transition_fade_out()
signal scene_transition_fade_in()
