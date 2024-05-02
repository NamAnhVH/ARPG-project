extends Node

const STAT_PATH = "res://data/json/stats.json"
const LEVEL_PATH = "res://data/json/level.json"
const MAP_PATH = "res://data/json/map.json"
const QUEST_PATH = "res://data/json/quest.json"
const STORY_PATH = "res://data/json/story.json"

var sprites = {
	"sword_v00": preload("res://assets/items/sword_v00.png"),
	"sword_v01": preload("res://assets/items/sword_v01.png"),
	"sword_v02": preload("res://assets/items/sword_v02.png"),
	"sword_v03": preload("res://assets/items/sword_v03.png"),
	"sword_v04": preload("res://assets/items/sword_v04.png"),
	"axe_v00": preload("res://assets/items/axe_v00.png"),
	"axe_v01": preload("res://assets/items/axe_v01.png"),
	"axe_v02": preload("res://assets/items/axe_v02.png"),
	"axe_v03": preload("res://assets/items/axe_v03.png"),
	"axe_v04": preload("res://assets/items/axe_v04.png"),
	"mace_v00": preload("res://assets/items/mace_v00.png"),
	"mace_v01": preload("res://assets/items/mace_v01.png"),
	"mace_v02": preload("res://assets/items/mace_v02.png"),
	"mace_v03": preload("res://assets/items/mace_v03.png"),
	"mace_v04": preload("res://assets/items/mace_v04.png"),
	"spear_v00": preload("res://assets/items/spear_v00.png"),
	"spear_v01": preload("res://assets/items/spear_v01.png"),
	"spear_v02": preload("res://assets/items/spear_v02.png"),
	"spear_v03": preload("res://assets/items/spear_v03.png"),
	"spear_v04": preload("res://assets/items/spear_v04.png"),
	"heavy_spear_v00": preload("res://assets/items/heavy_spear_v00.png"),
	"heavy_spear_v01": preload("res://assets/items/heavy_spear_v01.png"),
	"heavy_spear_v02": preload("res://assets/items/heavy_spear_v02.png"),
	"heavy_spear_v03": preload("res://assets/items/heavy_spear_v03.png"),
	"heavy_spear_v04": preload("res://assets/items/heavy_spear_v04.png"),
	"axe_spear_v00": preload("res://assets/items/axe_spear_v00.png"),
	"axe_spear_v01": preload("res://assets/items/axe_spear_v01.png"),
	"axe_spear_v02": preload("res://assets/items/axe_spear_v02.png"),
	"axe_spear_v03": preload("res://assets/items/axe_spear_v03.png"),
	"axe_spear_v04": preload("res://assets/items/axe_spear_v04.png"),
	"bow_v00": preload("res://assets/items/bow_v00.png"),
	"bow_v01": preload("res://assets/items/bow_v01.png"),
	"bow_v02": preload("res://assets/items/bow_v02.png"),
	"bow_v03": preload("res://assets/items/bow_v03.png"),
	"bow_v04": preload("res://assets/items/bow_v04.png"),
	"long_bow_v00": preload("res://assets/items/long_bow_v00.png"),
	"long_bow_v01": preload("res://assets/items/long_bow_v01.png"),
	"long_bow_v02": preload("res://assets/items/long_bow_v02.png"),
	"long_bow_v03": preload("res://assets/items/long_bow_v03.png"),
	"long_bow_v04": preload("res://assets/items/long_bow_v04.png"),
	"recurve_v00": preload("res://assets/items/recurve_v00.png"),
	"recurve_v01": preload("res://assets/items/recurve_v01.png"),
	"recurve_v02": preload("res://assets/items/recurve_v02.png"),
	"recurve_v03": preload("res://assets/items/recurve_v03.png"),
	"recurve_v04": preload("res://assets/items/recurve_v04.png"),
	"shield_v00": preload("res://assets/items/shield_v00.png"),
	"shield_v01": preload("res://assets/items/shield_v01.png"),
	"shield_v02": preload("res://assets/items/shield_v02.png"),
	"shield_v03": preload("res://assets/items/shield_v03.png"),
	"shield_v04": preload("res://assets/items/shield_v04.png"),
	"heavy_shield_v00": preload("res://assets/items/heavy_shield_v00.png"),
	"heavy_shield_v01": preload("res://assets/items/heavy_shield_v01.png"),
	"heavy_shield_v02": preload("res://assets/items/heavy_shield_v02.png"),
	"heavy_shield_v03": preload("res://assets/items/heavy_shield_v03.png"),
	"heavy_shield_v04": preload("res://assets/items/heavy_shield_v04.png"),
	"knight_shield_v00": preload("res://assets/items/knight_shield_v00.png"),
	"knight_shield_v01": preload("res://assets/items/knight_shield_v01.png"),
	"knight_shield_v02": preload("res://assets/items/knight_shield_v02.png"),
	"knight_shield_v03": preload("res://assets/items/knight_shield_v03.png"),
	"knight_shield_v04": preload("res://assets/items/knight_shield_v04.png"),
	"quiver_v00": preload("res://assets/items/quiver_v00.png"),
	"quiver_v01": preload("res://assets/items/quiver_v01.png"),
	"quiver_v02": preload("res://assets/items/quiver_v02.png"),
	"quiver_v03": preload("res://assets/items/quiver_v03.png"),
	"quiver_v04": preload("res://assets/items/quiver_v04.png"),
	"quiver_v05": preload("res://assets/items/quiver_v05.png"),
	"quiver_v06": preload("res://assets/items/quiver_v06.png"),
	"quiver_v07": preload("res://assets/items/quiver_v07.png"),
	"armor_v00": preload("res://assets/items/armor_v00.png"),
	"armor_v01": preload("res://assets/items/armor_v01.png"),
	"armor_v02": preload("res://assets/items/armor_v02.png"),
	"armor_v03": preload("res://assets/items/armor_v03.png"),
	"armor_v04": preload("res://assets/items/armor_v04.png"),
	"armor_v05": preload("res://assets/items/armor_v05.png"),
	"armor_v06": preload("res://assets/items/armor_v06.png"),
	"armor_v07": preload("res://assets/items/armor_v07.png"),
	"armor_v08": preload("res://assets/items/armor_v08.png"),
	"armor_v09": preload("res://assets/items/armor_v09.png"),
	"armor_v10": preload("res://assets/items/armor_v10.png"),
	"armor_v11": preload("res://assets/items/armor_v11.png"),
	"armor_v12": preload("res://assets/items/armor_v12.png"),
	"armor_v13": preload("res://assets/items/armor_v13.png"),
	"armor_v14": preload("res://assets/items/armor_v14.png"),
	"armor_v15": preload("res://assets/items/armor_v15.png"),
	"helmet_v00": preload("res://assets/items/helmet_v00.png"),
	"helmet_v01": preload("res://assets/items/helmet_v01.png"),
	"helmet_v02": preload("res://assets/items/helmet_v02.png"),
	"helmet_v03": preload("res://assets/items/helmet_v03.png"),
	"helmet_v04": preload("res://assets/items/helmet_v04.png"),
	"helmet_v05": preload("res://assets/items/helmet_v05.png"),
	"helmet_v06": preload("res://assets/items/helmet_v06.png"),
	"helmet_v07": preload("res://assets/items/helmet_v07.png"),
	"helmet_v08": preload("res://assets/items/helmet_v08.png"),
	"helmet_v09": preload("res://assets/items/helmet_v09.png"),
	"helmet_v10": preload("res://assets/items/helmet_v10.png"),
	"helmet_v11": preload("res://assets/items/helmet_v11.png"),
	"helmet_v12": preload("res://assets/items/helmet_v12.png"),
	"helmet_v13": preload("res://assets/items/helmet_v13.png"),
	"helmet_v14": preload("res://assets/items/helmet_v14.png"),
	"helmet_v15": preload("res://assets/items/helmet_v15.png"),
	"shoes_v00": preload("res://assets/items/shoes_v00.png"),
	"shoes_v01": preload("res://assets/items/shoes_v01.png"),
	"shoes_v02": preload("res://assets/items/shoes_v02.png"),
	"shoes_v03": preload("res://assets/items/shoes_v03.png"),
	"shoes_v04": preload("res://assets/items/shoes_v04.png"),
	"shoes_v05": preload("res://assets/items/shoes_v05.png"),
	"shoes_v06": preload("res://assets/items/shoes_v06.png"),
	"shoes_v07": preload("res://assets/items/shoes_v07.png"),
	"shoes_v08": preload("res://assets/items/shoes_v08.png"),
	"shoes_v09": preload("res://assets/items/shoes_v09.png"),
	"shoes_v10": preload("res://assets/items/shoes_v10.png"),
	"shoes_v11": preload("res://assets/items/shoes_v11.png"),
	"shoes_v12": preload("res://assets/items/shoes_v12.png"),
	"shoes_v13": preload("res://assets/items/shoes_v13.png"),
	"shoes_v14": preload("res://assets/items/shoes_v14.png"),
	"shoes_v15": preload("res://assets/items/shoes_v15.png"),
	"necklace_v00": preload("res://assets/items/necklace_v00.png"),
	"necklace_v01": preload("res://assets/items/necklace_v01.png"),
	"necklace_v02": preload("res://assets/items/necklace_v02.png"),
	"necklace_v03": preload("res://assets/items/necklace_v03.png"),
	"necklace_v04": preload("res://assets/items/necklace_v04.png"),
	"necklace_v05": preload("res://assets/items/necklace_v05.png"),
	"necklace_v06": preload("res://assets/items/necklace_v06.png"),
	"necklace_v07": preload("res://assets/items/necklace_v07.png"),
	"necklace_v08": preload("res://assets/items/necklace_v08.png"),
	"necklace_v09": preload("res://assets/items/necklace_v09.png"),
	"necklace_v10": preload("res://assets/items/necklace_v10.png"),
	"necklace_v11": preload("res://assets/items/necklace_v11.png"),
	"ring_v00": preload("res://assets/items/ring_v00.png"),
	"ring_v01": preload("res://assets/items/ring_v01.png"),
	"ring_v02": preload("res://assets/items/ring_v02.png"),
	"ring_v03": preload("res://assets/items/ring_v03.png"),
	"ring_v04": preload("res://assets/items/ring_v04.png"),
	"ring_v05": preload("res://assets/items/ring_v05.png"),
	"ring_v06": preload("res://assets/items/ring_v06.png"),
	"ring_v07": preload("res://assets/items/ring_v07.png"),
	"ring_v08": preload("res://assets/items/ring_v08.png"),
	"ring_v09": preload("res://assets/items/ring_v09.png"),
	"ring_v10": preload("res://assets/items/ring_v10.png"),
	"ring_v11": preload("res://assets/items/ring_v11.png"),
	"ring_v12": preload("res://assets/items/ring_v12.png"),
	"ring_v13": preload("res://assets/items/ring_v13.png"),
	"ring_v14": preload("res://assets/items/ring_v14.png"),
	"ring_v15": preload("res://assets/items/ring_v15.png"),
	"stone": preload("res://assets/items/stone.png"),
	"coal": preload("res://assets/items/coal.png"),
	"iron": preload("res://assets/items/iron.png"),
	"copper": preload("res://assets/items/copper.png"),
	"silver": preload("res://assets/items/silver.png"),
	"gold": preload("res://assets/items/gold.png"),
	"healing_potion_v00": preload("res://assets/items/healing_potion_v00.png"),
	"healing_potion_v01": preload("res://assets/items/healing_potion_v01.png"),
	"healing_potion_v02": preload("res://assets/items/healing_potion_v02.png"),
	"healing_potion_v03": preload("res://assets/items/healing_potion_v03.png"),
	"healing_potion_v04": preload("res://assets/items/healing_potion_v04.png"),
}

var tscn = {
	"inventory_slot" : preload("res://sources/scenes/ui/inventory_slot.tscn"),
	"chest_slot": preload("res://sources/scenes/ui/chest_slot.tscn"),
	"hotbar_slot": preload("res://sources/scenes/ui/hotbar_slot.tscn"),
	"floor_item": preload("res://sources/scenes/interactables/floor_item.tscn"),
	"cooldown": preload("res://sources/scenes/usable/cooldown.tscn"),
	"quantity": preload("res://sources/scenes/usable/quantity.tscn"),
	"inventory": preload("res://sources/scenes/ui/inventory.tscn"),
	"equipment": preload("res://sources/scenes/ui/equipment.tscn"),
	"chest": preload("res://sources/scenes/ui/chest.tscn"),
	"indicator": preload("res://sources/scenes/ui/indicator.tscn"),
	"arrow": preload("res://sources/scenes/core/arrow.tscn"),
	"balloon": preload("res://sources/scenes/ui/balloon.tscn"),
	"shop_slot_container": preload("res://sources/scenes/ui/shop_slot_container.tscn"),
	"shop_slot": preload("res://sources/scenes/ui/shop_slot.tscn"),
	"setting_container": preload("res://sources/scenes/ui/setting_container.tscn"),
	"add_file_save_button": preload("res://sources/scenes/ui/add_file_save_button.tscn"),
	"file_saving_container": preload("res://sources/scenes/ui/file_saving_container.tscn"),
	"save_slot": preload("res://sources/scenes/ui/save_slot.tscn"),
	"choose_name_panel": preload("res://sources/scenes/ui/choose_name_panel.tscn"),
	"quest_available": preload("res://sources/scenes/ui/quest_available.tscn"),
	"quest_slot": preload("res://sources/scenes/ui/quest_slot.tscn"),
	"quest_name": preload("res://sources/scenes/ui/quest_name.tscn"),
	"quest_description": preload("res://sources/scenes/ui/quest_description.tscn"),
	"buff_slot": preload("res://sources/scenes/usable/buff_slot.tscn")
}

var character = {
	"luna": preload("res://sources/scenes/characters/npcs/luna.tscn"),
	"slime": preload("res://sources/scenes/characters/battleCharacters/enemies/slime.tscn"),
	"gremlin": preload("res://sources/scenes/characters/battleCharacters/enemies/gremlin.tscn")
}

var world = {
	"world_1": preload("res://sources/scenes/map/world_1.tscn"),
	"village": preload("res://sources/scenes/map/village.tscn"),
	"map_1": preload("res://sources/scenes/map/map_1.tscn"),
	"map_2": preload("res://sources/scenes/map/map_2.tscn"),
	"map_3": preload("res://sources/scenes/map/map_3.tscn"),
	"map_4": preload("res://sources/scenes/map/map_4.tscn"),
	"map_5": preload("res://sources/scenes/map/map_5.tscn"),
	"map_6": preload("res://sources/scenes/map/map_6.tscn"),
	"map_7": preload("res://sources/scenes/map/map_7.tscn"),
	"map_8": preload("res://sources/scenes/map/map_8.tscn"),
	"map_9": preload("res://sources/scenes/map/map_9.tscn"),
	"map_10": preload("res://sources/scenes/map/map_10.tscn"),
	"map_11": preload("res://sources/scenes/map/map_11.tscn"),
	"map_12": preload("res://sources/scenes/map/map_12.tscn"),
	"map_13": preload("res://sources/scenes/map/map_13.tscn"),
	"map_14": preload("res://sources/scenes/map/map_14.tscn"),
	"map_15": preload("res://sources/scenes/map/map_15.tscn"),
	"map_16": preload("res://sources/scenes/map/map_16.tscn"),
	"map_17": preload("res://sources/scenes/map/map_17.tscn"),
	"map_18": preload("res://sources/scenes/map/map_18.tscn"),
	"map_19": preload("res://sources/scenes/map/map_19.tscn"),
	"map_20": preload("res://sources/scenes/map/map_20.tscn"),
	"map_21": preload("res://sources/scenes/map/map_21.tscn"),
	"map_22": preload("res://sources/scenes/map/map_22.tscn"),
	"map_23": preload("res://sources/scenes/map/map_23.tscn"),
	"map_24": preload("res://sources/scenes/map/map_24.tscn"),
	"map_25": preload("res://sources/scenes/map/map_25.tscn"),
	"luna_house": preload("res://sources/scenes/map/luna_house.tscn")
}

var resources = {
	"game_data": preload("res://data/resources/game_data.tres"),
	"player_data": preload("res://data/resources/player_data.tres"),
	"setting_data": preload("res://data/resources/setting_data.tres")
}

var weapon_texture = {
	GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON: {
		"attack": {
			"axe_v00": preload("res://assets/weapons/swordAndShield/attack/weapon/axe_v00.png"),
			"axe_v01": preload("res://assets/weapons/swordAndShield/attack/weapon/axe_v01.png"),
			"axe_v02": preload("res://assets/weapons/swordAndShield/attack/weapon/axe_v02.png"),
			"axe_v03": preload("res://assets/weapons/swordAndShield/attack/weapon/axe_v03.png"),
			"axe_v04": preload("res://assets/weapons/swordAndShield/attack/weapon/axe_v04.png"),
			"mace_v00": preload("res://assets/weapons/swordAndShield/attack/weapon/mace_v00.png"),
			"mace_v01": preload("res://assets/weapons/swordAndShield/attack/weapon/mace_v01.png"),
			"mace_v02": preload("res://assets/weapons/swordAndShield/attack/weapon/mace_v02.png"),
			"mace_v03": preload("res://assets/weapons/swordAndShield/attack/weapon/mace_v03.png"),
			"mace_v04": preload("res://assets/weapons/swordAndShield/attack/weapon/mace_v04.png"),
			"sword_v00": preload("res://assets/weapons/swordAndShield/attack/weapon/sword_v00.png"),
			"sword_v01": preload("res://assets/weapons/swordAndShield/attack/weapon/sword_v01.png"),
			"sword_v02": preload("res://assets/weapons/swordAndShield/attack/weapon/sword_v02.png"),
			"sword_v03": preload("res://assets/weapons/swordAndShield/attack/weapon/sword_v03.png"),
			"sword_v04": preload("res://assets/weapons/swordAndShield/attack/weapon/sword_v04.png")
		},
		"change_state": {
			"axe_v00": preload("res://assets/weapons/swordAndShield/changeState/weapon/axe_v00.png"),
			"axe_v01": preload("res://assets/weapons/swordAndShield/changeState/weapon/axe_v01.png"),
			"axe_v02": preload("res://assets/weapons/swordAndShield/changeState/weapon/axe_v02.png"),
			"axe_v03": preload("res://assets/weapons/swordAndShield/changeState/weapon/axe_v03.png"),
			"axe_v04": preload("res://assets/weapons/swordAndShield/changeState/weapon/axe_v04.png"),
			"mace_v00": preload("res://assets/weapons/swordAndShield/changeState/weapon/mace_v00.png"),
			"mace_v01": preload("res://assets/weapons/swordAndShield/changeState/weapon/mace_v01.png"),
			"mace_v02": preload("res://assets/weapons/swordAndShield/changeState/weapon/mace_v02.png"),
			"mace_v03": preload("res://assets/weapons/swordAndShield/changeState/weapon/mace_v03.png"),
			"mace_v04": preload("res://assets/weapons/swordAndShield/changeState/weapon/mace_v04.png"),
			"sword_v00": preload("res://assets/weapons/swordAndShield/changeState/weapon/sword_v00.png"),
			"sword_v01": preload("res://assets/weapons/swordAndShield/changeState/weapon/sword_v01.png"),
			"sword_v02": preload("res://assets/weapons/swordAndShield/changeState/weapon/sword_v02.png"),
			"sword_v03": preload("res://assets/weapons/swordAndShield/changeState/weapon/sword_v03.png"),
			"sword_v04": preload("res://assets/weapons/swordAndShield/changeState/weapon/sword_v04.png")
		},
		"move_idle": {
			"axe_v00": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/axe_v00.png"),
			"axe_v01": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/axe_v01.png"),
			"axe_v02": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/axe_v02.png"),
			"axe_v03": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/axe_v03.png"),
			"axe_v04": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/axe_v04.png"),
			"mace_v00": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/mace_v00.png"),
			"mace_v01": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/mace_v01.png"),
			"mace_v02": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/mace_v02.png"),
			"mace_v03": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/mace_v03.png"),
			"mace_v04": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/mace_v04.png"),
			"sword_v00": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/sword_v00.png"),
			"sword_v01": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/sword_v01.png"),
			"sword_v02": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/sword_v02.png"),
			"sword_v03": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/sword_v03.png"),
			"sword_v04": preload("res://assets/weapons/swordAndShield/moveIdle/weapon/sword_v04.png")
		},
		"stand_move_push": {
			"axe_v00": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/axe_v00.png"),
			"axe_v01": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/axe_v01.png"),
			"axe_v02": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/axe_v02.png"),
			"axe_v03": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/axe_v03.png"),
			"axe_v04": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/axe_v04.png"),
			"mace_v00": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/mace_v00.png"),
			"mace_v01": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/mace_v01.png"),
			"mace_v02": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/mace_v02.png"),
			"mace_v03": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/mace_v03.png"),
			"mace_v04": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/mace_v04.png"),
			"sword_v00": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/sword_v00.png"),
			"sword_v01": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/sword_v01.png"),
			"sword_v02": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/sword_v02.png"),
			"sword_v03": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/sword_v03.png"),
			"sword_v04": preload("res://assets/weapons/swordAndShield/standMovePush/weapon/sword_v04.png")
		}
	},
	GameEnums.WEAPON_TYPE.SPEAR: {
		"attack": {
			"spear_v00": preload("res://assets/weapons/spear/attack/spear_v00.png"),
			"spear_v01": preload("res://assets/weapons/spear/attack/spear_v01.png"),
			"spear_v02": preload("res://assets/weapons/spear/attack/spear_v02.png"),
			"spear_v03": preload("res://assets/weapons/spear/attack/spear_v03.png"),
			"spear_v04": preload("res://assets/weapons/spear/attack/spear_v04.png"),
			"heavy_spear_v00": preload("res://assets/weapons/spear/attack/heavy_spear_v00.png"),
			"heavy_spear_v01": preload("res://assets/weapons/spear/attack/heavy_spear_v01.png"),
			"heavy_spear_v02": preload("res://assets/weapons/spear/attack/heavy_spear_v02.png"),
			"heavy_spear_v03": preload("res://assets/weapons/spear/attack/heavy_spear_v03.png"),
			"heavy_spear_v04": preload("res://assets/weapons/spear/attack/heavy_spear_v04.png"),
			"axe_spear_v00": preload("res://assets/weapons/spear/attack/axe_spear_v00.png"),
			"axe_spear_v01": preload("res://assets/weapons/spear/attack/axe_spear_v01.png"),
			"axe_spear_v02": preload("res://assets/weapons/spear/attack/axe_spear_v02.png"),
			"axe_spear_v03": preload("res://assets/weapons/spear/attack/axe_spear_v03.png"),
			"axe_spear_v04": preload("res://assets/weapons/spear/attack/axe_spear_v04.png")
		},
		"change_state": {
			"spear_v00": preload("res://assets/weapons/spear/changeState/spear_v00.png"),
			"spear_v01": preload("res://assets/weapons/spear/changeState/spear_v01.png"),
			"spear_v02": preload("res://assets/weapons/spear/changeState/spear_v02.png"),
			"spear_v03": preload("res://assets/weapons/spear/changeState/spear_v03.png"),
			"spear_v04": preload("res://assets/weapons/spear/changeState/spear_v04.png"),
			"heavy_spear_v00": preload("res://assets/weapons/spear/changeState/heavy_spear_v00.png"),
			"heavy_spear_v01": preload("res://assets/weapons/spear/changeState/heavy_spear_v01.png"),
			"heavy_spear_v02": preload("res://assets/weapons/spear/changeState/heavy_spear_v02.png"),
			"heavy_spear_v03": preload("res://assets/weapons/spear/changeState/heavy_spear_v03.png"),
			"heavy_spear_v04": preload("res://assets/weapons/spear/changeState/heavy_spear_v04.png"),
			"axe_spear_v00": preload("res://assets/weapons/spear/changeState/axe_spear_v00.png"),
			"axe_spear_v01": preload("res://assets/weapons/spear/changeState/axe_spear_v01.png"),
			"axe_spear_v02": preload("res://assets/weapons/spear/changeState/axe_spear_v02.png"),
			"axe_spear_v03": preload("res://assets/weapons/spear/changeState/axe_spear_v03.png"),
			"axe_spear_v04": preload("res://assets/weapons/spear/changeState/axe_spear_v04.png")
		},
		"move_idle": {
			"spear_v00": preload("res://assets/weapons/spear/moveIdle/spear_v00.png"),
			"spear_v01": preload("res://assets/weapons/spear/moveIdle/spear_v01.png"),
			"spear_v02": preload("res://assets/weapons/spear/moveIdle/spear_v02.png"),
			"spear_v03": preload("res://assets/weapons/spear/moveIdle/spear_v03.png"),
			"spear_v04": preload("res://assets/weapons/spear/moveIdle/spear_v04.png"),
			"heavy_spear_v00": preload("res://assets/weapons/spear/moveIdle/heavy_spear_v00.png"),
			"heavy_spear_v01": preload("res://assets/weapons/spear/moveIdle/heavy_spear_v01.png"),
			"heavy_spear_v02": preload("res://assets/weapons/spear/moveIdle/heavy_spear_v02.png"),
			"heavy_spear_v03": preload("res://assets/weapons/spear/moveIdle/heavy_spear_v03.png"),
			"heavy_spear_v04": preload("res://assets/weapons/spear/moveIdle/heavy_spear_v04.png"),
			"axe_spear_v00": preload("res://assets/weapons/spear/moveIdle/axe_spear_v00.png"),
			"axe_spear_v01": preload("res://assets/weapons/spear/moveIdle/axe_spear_v01.png"),
			"axe_spear_v02": preload("res://assets/weapons/spear/moveIdle/axe_spear_v02.png"),
			"axe_spear_v03": preload("res://assets/weapons/spear/moveIdle/axe_spear_v03.png"),
			"axe_spear_v04": preload("res://assets/weapons/spear/moveIdle/axe_spear_v04.png")
		},
		"stand_move_push": {
			"spear_v00": preload("res://assets/weapons/spear/standMovePush/spear_v00.png"),
			"spear_v01": preload("res://assets/weapons/spear/standMovePush/spear_v01.png"),
			"spear_v02": preload("res://assets/weapons/spear/standMovePush/spear_v02.png"),
			"spear_v03": preload("res://assets/weapons/spear/standMovePush/spear_v03.png"),
			"spear_v04": preload("res://assets/weapons/spear/standMovePush/spear_v04.png"),
			"heavy_spear_v00": preload("res://assets/weapons/spear/standMovePush/heavy_spear_v00.png"),
			"heavy_spear_v01": preload("res://assets/weapons/spear/standMovePush/heavy_spear_v01.png"),
			"heavy_spear_v02": preload("res://assets/weapons/spear/standMovePush/heavy_spear_v02.png"),
			"heavy_spear_v03": preload("res://assets/weapons/spear/standMovePush/heavy_spear_v03.png"),
			"heavy_spear_v04": preload("res://assets/weapons/spear/standMovePush/heavy_spear_v04.png"),
			"axe_spear_v00": preload("res://assets/weapons/spear/standMovePush/axe_spear_v00.png"),
			"axe_spear_v01": preload("res://assets/weapons/spear/standMovePush/axe_spear_v01.png"),
			"axe_spear_v02": preload("res://assets/weapons/spear/standMovePush/axe_spear_v02.png"),
			"axe_spear_v03": preload("res://assets/weapons/spear/standMovePush/axe_spear_v03.png"),
			"axe_spear_v04": preload("res://assets/weapons/spear/standMovePush/axe_spear_v04.png")
		}
	},
	GameEnums.WEAPON_TYPE.BOW: {
		"attack": {
			"bow_v00": preload("res://assets/weapons/bow/attack/weapon/bow_v00.png"),
			"bow_v01": preload("res://assets/weapons/bow/attack/weapon/bow_v01.png"),
			"bow_v02": preload("res://assets/weapons/bow/attack/weapon/bow_v02.png"),
			"bow_v03": preload("res://assets/weapons/bow/attack/weapon/bow_v03.png"),
			"bow_v04": preload("res://assets/weapons/bow/attack/weapon/bow_v04.png"),
			"long_bow_v00": preload("res://assets/weapons/bow/attack/weapon/long_bow_v00.png"),
			"long_bow_v01": preload("res://assets/weapons/bow/attack/weapon/long_bow_v01.png"),
			"long_bow_v02": preload("res://assets/weapons/bow/attack/weapon/long_bow_v02.png"),
			"long_bow_v03": preload("res://assets/weapons/bow/attack/weapon/long_bow_v03.png"),
			"long_bow_v04": preload("res://assets/weapons/bow/attack/weapon/long_bow_v04.png"),
			"recurve_v00": preload("res://assets/weapons/bow/attack/weapon/recurve_v00.png"),
			"recurve_v01": preload("res://assets/weapons/bow/attack/weapon/recurve_v01.png"),
			"recurve_v02": preload("res://assets/weapons/bow/attack/weapon/recurve_v02.png"),
			"recurve_v03": preload("res://assets/weapons/bow/attack/weapon/recurve_v03.png"),
			"recurve_v04": preload("res://assets/weapons/bow/attack/weapon/recurve_v04.png")
		},
		"change_state": {
			"bow_v00": preload("res://assets/weapons/bow/changeState/weapon/bow_v00.png"),
			"bow_v01": preload("res://assets/weapons/bow/changeState/weapon/bow_v01.png"),
			"bow_v02": preload("res://assets/weapons/bow/changeState/weapon/bow_v02.png"),
			"bow_v03": preload("res://assets/weapons/bow/changeState/weapon/bow_v03.png"),
			"bow_v04": preload("res://assets/weapons/bow/changeState/weapon/bow_v04.png"),
			"long_bow_v00": preload("res://assets/weapons/bow/changeState/weapon/long_bow_v00.png"),
			"long_bow_v01": preload("res://assets/weapons/bow/changeState/weapon/long_bow_v01.png"),
			"long_bow_v02": preload("res://assets/weapons/bow/changeState/weapon/long_bow_v02.png"),
			"long_bow_v03": preload("res://assets/weapons/bow/changeState/weapon/long_bow_v03.png"),
			"long_bow_v04": preload("res://assets/weapons/bow/changeState/weapon/long_bow_v04.png"),
			"recurve_v00": preload("res://assets/weapons/bow/changeState/weapon/recurve_v00.png"),
			"recurve_v01": preload("res://assets/weapons/bow/changeState/weapon/recurve_v01.png"),
			"recurve_v02": preload("res://assets/weapons/bow/changeState/weapon/recurve_v02.png"),
			"recurve_v03": preload("res://assets/weapons/bow/changeState/weapon/recurve_v03.png"),
			"recurve_v04": preload("res://assets/weapons/bow/changeState/weapon/recurve_v04.png")
		},
		"move_idle": {
			"bow_v00": preload("res://assets/weapons/bow/moveIdle/weapon/bow_v00.png"),
			"bow_v01": preload("res://assets/weapons/bow/moveIdle/weapon/bow_v01.png"),
			"bow_v02": preload("res://assets/weapons/bow/moveIdle/weapon/bow_v02.png"),
			"bow_v03": preload("res://assets/weapons/bow/moveIdle/weapon/bow_v03.png"),
			"bow_v04": preload("res://assets/weapons/bow/moveIdle/weapon/bow_v04.png"),
			"long_bow_v00": preload("res://assets/weapons/bow/moveIdle/weapon/long_bow_v00.png"),
			"long_bow_v01": preload("res://assets/weapons/bow/moveIdle/weapon/long_bow_v01.png"),
			"long_bow_v02": preload("res://assets/weapons/bow/moveIdle/weapon/long_bow_v02.png"),
			"long_bow_v03": preload("res://assets/weapons/bow/moveIdle/weapon/long_bow_v03.png"),
			"long_bow_v04": preload("res://assets/weapons/bow/moveIdle/weapon/long_bow_v04.png"),
			"recurve_v00": preload("res://assets/weapons/bow/moveIdle/weapon/recurve_v00.png"),
			"recurve_v01": preload("res://assets/weapons/bow/moveIdle/weapon/recurve_v01.png"),
			"recurve_v02": preload("res://assets/weapons/bow/moveIdle/weapon/recurve_v02.png"),
			"recurve_v03": preload("res://assets/weapons/bow/moveIdle/weapon/recurve_v03.png"),
			"recurve_v04": preload("res://assets/weapons/bow/moveIdle/weapon/recurve_v04.png")
		},
		"stand_move_push": {
			"bow_v00": preload("res://assets/weapons/bow/standMovePush/weapon/bow_v00.png"),
			"bow_v01": preload("res://assets/weapons/bow/standMovePush/weapon/bow_v01.png"),
			"bow_v02": preload("res://assets/weapons/bow/standMovePush/weapon/bow_v02.png"),
			"bow_v03": preload("res://assets/weapons/bow/standMovePush/weapon/bow_v03.png"),
			"bow_v04": preload("res://assets/weapons/bow/standMovePush/weapon/bow_v04.png"),
			"long_bow_v00": preload("res://assets/weapons/bow/standMovePush/weapon/long_bow_v00.png"),
			"long_bow_v01": preload("res://assets/weapons/bow/standMovePush/weapon/long_bow_v01.png"),
			"long_bow_v02": preload("res://assets/weapons/bow/standMovePush/weapon/long_bow_v02.png"),
			"long_bow_v03": preload("res://assets/weapons/bow/standMovePush/weapon/long_bow_v03.png"),
			"long_bow_v04": preload("res://assets/weapons/bow/standMovePush/weapon/long_bow_v04.png"),
			"recurve_v00": preload("res://assets/weapons/bow/standMovePush/weapon/recurve_v00.png"),
			"recurve_v01": preload("res://assets/weapons/bow/standMovePush/weapon/recurve_v01.png"),
			"recurve_v02": preload("res://assets/weapons/bow/standMovePush/weapon/recurve_v02.png"),
			"recurve_v03": preload("res://assets/weapons/bow/standMovePush/weapon/recurve_v03.png"),
			"recurve_v04": preload("res://assets/weapons/bow/standMovePush/weapon/recurve_v04.png")
		}
	}
}

var extra_weapon_texture = {
	GameEnums.EXTRA_WEAPON_TYPE.SHIELD: {
		"attack": {
			"shield_v00": preload("res://assets/weapons/swordAndShield/attack/shield/shield_v00.png"),
			"shield_v01": preload("res://assets/weapons/swordAndShield/attack/shield/shield_v01.png"),
			"shield_v02": preload("res://assets/weapons/swordAndShield/attack/shield/shield_v02.png"),
			"shield_v03": preload("res://assets/weapons/swordAndShield/attack/shield/shield_v03.png"),
			"shield_v04": preload("res://assets/weapons/swordAndShield/attack/shield/shield_v04.png"),
			"heavy_shield_v00": preload("res://assets/weapons/swordAndShield/attack/shield/heavy_shield_v00.png"),
			"heavy_shield_v01": preload("res://assets/weapons/swordAndShield/attack/shield/heavy_shield_v01.png"),
			"heavy_shield_v02": preload("res://assets/weapons/swordAndShield/attack/shield/heavy_shield_v02.png"),
			"heavy_shield_v03": preload("res://assets/weapons/swordAndShield/attack/shield/heavy_shield_v03.png"),
			"heavy_shield_v04": preload("res://assets/weapons/swordAndShield/attack/shield/heavy_shield_v04.png"),
			"knight_shield_v00": preload("res://assets/weapons/swordAndShield/attack/shield/knight_shield_v00.png"),
			"knight_shield_v01": preload("res://assets/weapons/swordAndShield/attack/shield/knight_shield_v01.png"),
			"knight_shield_v02": preload("res://assets/weapons/swordAndShield/attack/shield/knight_shield_v02.png"),
			"knight_shield_v03": preload("res://assets/weapons/swordAndShield/attack/shield/knight_shield_v03.png"),
			"knight_shield_v04": preload("res://assets/weapons/swordAndShield/attack/shield/knight_shield_v04.png"),
		},
		"change_state": {
			"shield_v00": preload("res://assets/weapons/swordAndShield/changeState/shield/shield_v00.png"),
			"shield_v01": preload("res://assets/weapons/swordAndShield/changeState/shield/shield_v01.png"),
			"shield_v02": preload("res://assets/weapons/swordAndShield/changeState/shield/shield_v02.png"),
			"shield_v03": preload("res://assets/weapons/swordAndShield/changeState/shield/shield_v03.png"),
			"shield_v04": preload("res://assets/weapons/swordAndShield/changeState/shield/shield_v04.png"),
			"heavy_shield_v00": preload("res://assets/weapons/swordAndShield/changeState/shield/heavy_shield_v00.png"),
			"heavy_shield_v01": preload("res://assets/weapons/swordAndShield/changeState/shield/heavy_shield_v01.png"),
			"heavy_shield_v02": preload("res://assets/weapons/swordAndShield/changeState/shield/heavy_shield_v02.png"),
			"heavy_shield_v03": preload("res://assets/weapons/swordAndShield/changeState/shield/heavy_shield_v03.png"),
			"heavy_shield_v04": preload("res://assets/weapons/swordAndShield/changeState/shield/heavy_shield_v04.png"),
			"knight_shield_v00": preload("res://assets/weapons/swordAndShield/changeState/shield/knight_shield_v00.png"),
			"knight_shield_v01": preload("res://assets/weapons/swordAndShield/changeState/shield/knight_shield_v01.png"),
			"knight_shield_v02": preload("res://assets/weapons/swordAndShield/changeState/shield/knight_shield_v02.png"),
			"knight_shield_v03": preload("res://assets/weapons/swordAndShield/changeState/shield/knight_shield_v03.png"),
			"knight_shield_v04": preload("res://assets/weapons/swordAndShield/changeState/shield/knight_shield_v04.png")
		},
		"move_idle": {
			"shield_v00": preload("res://assets/weapons/swordAndShield/moveIdle/shield/shield_v00.png"),
			"shield_v01": preload("res://assets/weapons/swordAndShield/moveIdle/shield/shield_v01.png"),
			"shield_v02": preload("res://assets/weapons/swordAndShield/moveIdle/shield/shield_v02.png"),
			"shield_v03": preload("res://assets/weapons/swordAndShield/moveIdle/shield/shield_v03.png"),
			"shield_v04": preload("res://assets/weapons/swordAndShield/moveIdle/shield/shield_v04.png"),
			"heavy_shield_v00": preload("res://assets/weapons/swordAndShield/moveIdle/shield/heavy_shield_v00.png"),
			"heavy_shield_v01": preload("res://assets/weapons/swordAndShield/moveIdle/shield/heavy_shield_v01.png"),
			"heavy_shield_v02": preload("res://assets/weapons/swordAndShield/moveIdle/shield/heavy_shield_v02.png"),
			"heavy_shield_v03": preload("res://assets/weapons/swordAndShield/moveIdle/shield/heavy_shield_v03.png"),
			"heavy_shield_v04": preload("res://assets/weapons/swordAndShield/moveIdle/shield/heavy_shield_v04.png"),
			"knight_shield_v00": preload("res://assets/weapons/swordAndShield/moveIdle/shield/knight_shield_v00.png"),
			"knight_shield_v01": preload("res://assets/weapons/swordAndShield/moveIdle/shield/knight_shield_v01.png"),
			"knight_shield_v02": preload("res://assets/weapons/swordAndShield/moveIdle/shield/knight_shield_v02.png"),
			"knight_shield_v03": preload("res://assets/weapons/swordAndShield/moveIdle/shield/knight_shield_v03.png"),
			"knight_shield_v04": preload("res://assets/weapons/swordAndShield/moveIdle/shield/knight_shield_v04.png")
		},
		"stand_move_push": {
			"shield_v00": preload("res://assets/weapons/swordAndShield/standMovePush/shield/shield_v00.png"),
			"shield_v01": preload("res://assets/weapons/swordAndShield/standMovePush/shield/shield_v01.png"),
			"shield_v02": preload("res://assets/weapons/swordAndShield/standMovePush/shield/shield_v02.png"),
			"shield_v03": preload("res://assets/weapons/swordAndShield/standMovePush/shield/shield_v03.png"),
			"shield_v04": preload("res://assets/weapons/swordAndShield/standMovePush/shield/shield_v04.png"),
			"heavy_shield_v00": preload("res://assets/weapons/swordAndShield/standMovePush/shield/heavy_shield_v00.png"),
			"heavy_shield_v01": preload("res://assets/weapons/swordAndShield/standMovePush/shield/heavy_shield_v01.png"),
			"heavy_shield_v02": preload("res://assets/weapons/swordAndShield/standMovePush/shield/heavy_shield_v02.png"),
			"heavy_shield_v03": preload("res://assets/weapons/swordAndShield/standMovePush/shield/heavy_shield_v03.png"),
			"heavy_shield_v04": preload("res://assets/weapons/swordAndShield/standMovePush/shield/heavy_shield_v04.png"),
			"knight_shield_v00": preload("res://assets/weapons/swordAndShield/standMovePush/shield/knight_shield_v00.png"),
			"knight_shield_v01": preload("res://assets/weapons/swordAndShield/standMovePush/shield/knight_shield_v01.png"),
			"knight_shield_v02": preload("res://assets/weapons/swordAndShield/standMovePush/shield/knight_shield_v02.png"),
			"knight_shield_v03": preload("res://assets/weapons/swordAndShield/standMovePush/shield/knight_shield_v03.png"),
			"knight_shield_v04": preload("res://assets/weapons/swordAndShield/standMovePush/shield/knight_shield_v04.png")
		}
	},
	GameEnums.EXTRA_WEAPON_TYPE.QUIVER: {
		"attack": {
			"quiver_v00": preload("res://assets/weapons/bow/attack/quiver/quiver_v00.png"),
			"quiver_v01": preload("res://assets/weapons/bow/attack/quiver/quiver_v01.png"),
			"quiver_v02": preload("res://assets/weapons/bow/attack/quiver/quiver_v02.png"),
			"quiver_v03": preload("res://assets/weapons/bow/attack/quiver/quiver_v03.png"),
			"quiver_v04": preload("res://assets/weapons/bow/attack/quiver/quiver_v04.png"),
			"quiver_v05": preload("res://assets/weapons/bow/attack/quiver/quiver_v05.png"),
			"quiver_v06": preload("res://assets/weapons/bow/attack/quiver/quiver_v06.png"),
			"quiver_v07": preload("res://assets/weapons/bow/attack/quiver/quiver_v07.png")
		},
		"change_state": {
			"quiver_v00": preload("res://assets/weapons/bow/changeState/quiver/quiver_v00.png"),
			"quiver_v01": preload("res://assets/weapons/bow/changeState/quiver/quiver_v01.png"),
			"quiver_v02": preload("res://assets/weapons/bow/changeState/quiver/quiver_v02.png"),
			"quiver_v03": preload("res://assets/weapons/bow/changeState/quiver/quiver_v03.png"),
			"quiver_v04": preload("res://assets/weapons/bow/changeState/quiver/quiver_v04.png"),
			"quiver_v05": preload("res://assets/weapons/bow/changeState/quiver/quiver_v05.png"),
			"quiver_v06": preload("res://assets/weapons/bow/changeState/quiver/quiver_v06.png"),
			"quiver_v07": preload("res://assets/weapons/bow/changeState/quiver/quiver_v07.png")
		},
		"move_idle": {
			"quiver_v00": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v00.png"),
			"quiver_v01": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v01.png"),
			"quiver_v02": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v02.png"),
			"quiver_v03": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v03.png"),
			"quiver_v04": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v04.png"),
			"quiver_v05": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v05.png"),
			"quiver_v06": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v06.png"),
			"quiver_v07": preload("res://assets/weapons/bow/moveIdle/quiver/quiver_v07.png")
		},
		"stand_move_push": {
			"quiver_v00": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v00.png"),
			"quiver_v01": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v01.png"),
			"quiver_v02": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v02.png"),
			"quiver_v03": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v03.png"),
			"quiver_v04": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v04.png"),
			"quiver_v05": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v05.png"),
			"quiver_v06": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v06.png"),
			"quiver_v07": preload("res://assets/weapons/bow/standMovePush/quiver/quiver_v07.png")
		}
	}
}

var player_character_texture = {
	"base": {
		"stand_move_push": {
			"humn_v00": preload("res://assets/characters/swordAndShieldBase/standMovePush/humn_v00.png")
		}
	},
	GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON: {
		"attack": {
			"humn_v00": preload("res://assets/characters/swordAndShieldBase/attack/humn_v00.png")
		},
		"change_state": {
			"humn_v00": preload("res://assets/characters/swordAndShieldBase/changeState/humn_v00.png")
		},
		"move_idle": {
			"humn_v00": preload("res://assets/characters/swordAndShieldBase/moveIdle/humn_v00.png")
		},
		"stand_move_push": {
			"humn_v00": preload("res://assets/characters/swordAndShieldBase/standMovePush/humn_v00.png")
		}
	},
	GameEnums.WEAPON_TYPE.SPEAR: {
		"attack": {
			"humn_v00": preload("res://assets/characters/spearBase/attack/humn_v00.png")
		},
		"change_state": {
			"humn_v00": preload("res://assets/characters/spearBase/changeState/humn_v00.png")
		},
		"move_idle": {
			"humn_v00": preload("res://assets/characters/spearBase/moveIdle/humn_v00.png")
		},
		"stand_move_push": {
			"humn_v00": preload("res://assets/characters/spearBase/standMovePush/humn_v00.png")
		}
	},
	GameEnums.WEAPON_TYPE.BOW: {
		"attack": {
			"humn_v00": preload("res://assets/characters/bowBase/attack/humn_v00.png")
		},
		"change_state": {
			"humn_v00": preload("res://assets/characters/bowBase/changeState/humn_v00.png")
		},
		"move_idle": {
			"humn_v00": preload("res://assets/characters/bowBase/moveIdle/humn_v00.png")
		},
		"stand_move_push": {
			"humn_v00": preload("res://assets/characters/bowBase/standMovePush/humn_v00.png")
		}
	}
}

var arrow_texture = {
	"quiver_v00": preload("res://assets/weapons/bow/attack/arrow/quiver_v00.png"),
	"quiver_v01": preload("res://assets/weapons/bow/attack/arrow/quiver_v01.png"),
	"quiver_v02": preload("res://assets/weapons/bow/attack/arrow/quiver_v02.png"),
	"quiver_v03": preload("res://assets/weapons/bow/attack/arrow/quiver_v03.png"),
	"quiver_v04": preload("res://assets/weapons/bow/attack/arrow/quiver_v04.png"),
	"quiver_v05": preload("res://assets/weapons/bow/attack/arrow/quiver_v05.png"),
	"quiver_v06": preload("res://assets/weapons/bow/attack/arrow/quiver_v06.png"),
	"quiver_v07": preload("res://assets/weapons/bow/attack/arrow/quiver_v07.png")
}

var dialogue = {
	"merchant": preload("res://dialogues/merchant.dialogue"),
	"start_game": preload("res://dialogues/start_game.dialogue"),
	"default": preload("res://dialogues/default.dialogue"),
	"main_quest_1": preload("res://dialogues/main_quest_1.dialogue"),
	"main_quest_2": preload("res://dialogues/main_quest_2.dialogue"),
	"main_quest_3": preload("res://dialogues/main_quest_3.dialogue"),
	"main_quest_4": preload("res://dialogues/main_quest_4.dialogue"),
	"side_quest_1": preload("res://dialogues/side_quest_1.dialogue"),
	"side_quest_2": preload("res://dialogues/side_quest_2.dialogue")
	
}

var colors = {
	GameEnums.RARITY.COMMON : "000000",
	GameEnums.RARITY.UNCOMMON : "009623",
	GameEnums.RARITY.RARE : "0090FF",
	GameEnums.RARITY.UNIQUE : "FF00FF",
	GameEnums.RARITY.EPIC : "9C00FF",
	GameEnums.RARITY.DIVINE : "FF4500",
	GameEnums.RARITY.LEGENDARY : "FF0000",
}

var stat_info = {}
var level_info = {}
var map_info = {}
var quest_info = {}
var story_info = []

func _ready():
	var file = FileAccess.open(STAT_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	for stat in data:
		stat_info[GameEnums.STAT[stat]] = data[stat]
	file.close()
	
	var level_file = FileAccess.open(LEVEL_PATH, FileAccess.READ)
	level_info = JSON.parse_string(level_file.get_as_text())
	level_file.close()
	
	var map_file = FileAccess.open(MAP_PATH, FileAccess.READ)
	map_info = JSON.parse_string(map_file.get_as_text())
	map_file.close()
	
	var quest_file = FileAccess.open(QUEST_PATH, FileAccess.READ)
	quest_info = JSON.parse_string(quest_file.get_as_text())
	quest_file.close()
	
	var story_file = FileAccess.open(STORY_PATH, FileAccess.READ)
	story_info = JSON.parse_string(story_file.get_as_text())
	story_file.close()

func set_font(font_size: int, color = "000000"):
	var label_setting = LabelSettings.new()
	label_setting.font = preload("res://font/m5x7.ttf")
	label_setting.font_size = font_size
	label_setting.font_color = Color(color)
	return label_setting

func get_instance(id):
	return tscn[id].instantiate()

func get_map(id):
	return world[id].instantiate()

func get_character(id):
	return character[id].instantiate()
