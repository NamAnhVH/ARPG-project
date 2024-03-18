extends Node

const STAT_PATH = "res://data/json/stats.json"

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
	"ring_v00": preload("res://assets/items/ring_v00.png"),
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
	"hotbar_slot": preload("res://sources/scenes/ui/hotbar_slot.tscn"),
	"floor_item": preload("res://sources/scenes/interactables/floor_item.tscn"),
	"cooldown": preload("res://sources/scenes/usable/cooldown.tscn"),
	"quantity": preload("res://sources/scenes/usable/quantity.tscn"),
	"inventory": preload("res://sources/scenes/ui/inventory.tscn"),
	"equipment": preload("res://sources/scenes/ui/equipment.tscn"),
	"chest": preload("res://sources/scenes/ui/chest.tscn")
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
	}
}

var colors = {
	GameEnums.RARITY.COMMON : "000000",
	GameEnums.RARITY.UNCOMMON : "009623",
	GameEnums.RARITY.RARE : "0090FF",
	GameEnums.RARITY.EPIC : "9C00FF",
	GameEnums.RARITY.LEGENDARY : "FF0000",
}

var stat_info = {}

func _ready():
	var file = FileAccess.open(STAT_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	for stat in data:
		stat_info[GameEnums.STAT[stat]] = data[stat]
	file.close()


func set_font(font_size: int, color = "000000"):
	var label_setting = LabelSettings.new()
	label_setting.font = preload("res://font/m5x7.ttf")
	label_setting.font_size = font_size
	label_setting.font_color = Color(color)
	return label_setting

func get_instance(id):
	return tscn[id].instantiate()

