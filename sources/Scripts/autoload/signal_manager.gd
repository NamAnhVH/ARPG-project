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
signal item_changed()

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
signal choose_player_name
signal player_name(player_name: String)

#Enemy
signal enemy_died(enemy)

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
signal close_file_saving_container
signal update_file_saving_container
signal saving_game()

#Change scene
signal scene_transition_fade_out()
signal scene_transition_fade_in()
signal scene_transition_fade_in_finished

#Dialogue
signal show_dialogue(dialogue: String, branch: String)

#Game
signal pause_game
signal resume_game

#NPC Behavior
signal luna_go_out

#Story
signal change_next_progress
signal quest_updated
signal show_quest
signal show_quest_description(quest: String, type: String)

#Quest
signal update_main_quest(quest: String)
signal update_side_quest(quest: String)
signal main_quest_finished(quest: String)
signal main_quest_1_talk_to_guard


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
