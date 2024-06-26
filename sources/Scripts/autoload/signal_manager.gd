extends Node

#Inventory
signal inventory_opened
signal inventory_ready
signal inventory_closed
signal get_inventory_data
signal set_inventory_data(inventory: Inventory)
signal equipment_ready()
signal get_equipment_data()
signal set_equipment_data(equipment: Equipment)
signal hotbar_ready(hotbar: Hotbar)
signal chest_opened(chest: InteractableChest)
signal chest_ready(chest: Chest)
signal chest_closed(chest: InteractableChest)
signal content_changed()
signal inventory_add_item(item: Item)

#Shop
signal set_shop(npc_name: String)
signal shop_opened(list_item : Array[ShopItem])
signal shop_closed()
signal shop_ready(shop: Shop)
signal buy_item(price: int)
signal sell_item_opened
signal sell_item_closed
signal sell_item_ready

#Upgrade
signal upgrade_opened
signal upgrade_closed
signal upgrade_ready(upgrade: Upgrade)

#Interactable
signal open_chest(chest: InteractableChest)
signal chest_updated(chest: InteractableChest)
signal item_dropped(item: Item)

#PlayableCharacter
signal player_life_changed(health, max_health)
signal equip_item(item)
signal unequip_item(equipment_type)
signal gain_money(value: int)
signal gain_exp(value: int)
signal level_up
signal choose_player_name
signal player_name(player_name: String)
signal player_dead

#Item usage
signal heal_player(amount)
signal buff_player(amount, type, effective_time)

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
signal change_map(map: Map)
signal change_world(map_id: String, location: Vector2)
signal set_player()
signal clear_hidden_node()
signal generate_dungeon

#SaveManager
signal close_file_saving_container
signal update_file_saving_container
signal saving_game

#Change scene
signal scene_transition_fade_out
signal scene_transition_fade_in
signal scene_transition_fade_in_finished

#Dialogue
signal show_dialogue(dialogue: String, branch: String)

#Game
signal pause_game
signal resume_game

#Stat
signal update_stat

#NPC Behavior
signal luna_go_out

#Story
signal change_next_progress
signal quest_updated
signal show_quest
signal update_quest_progress(quest: String, type: GameEnums.QUEST_TYPE, finished: bool)
signal show_quest_description(quest: String, type: String)

#Quest
signal update_main_quest(quest: String)
signal update_side_quest(quest: String)
signal main_quest_finished(quest: String)
signal main_quest_1_talk_to_echo_1

#Boss
signal set_boss(boss: Boss)
signal new_boss_health(health)
