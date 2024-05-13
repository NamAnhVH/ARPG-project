extends QuestableCharacter

func _ready():
	super._ready()
	SignalManager.main_quest_1_talk_to_echo_1.connect(give_item)

func give_item():
	var item = ItemManager.get_item("sword_v00")
	SignalManager.inventory_add_item.emit(item)

