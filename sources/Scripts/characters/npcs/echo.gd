extends QuestableCharacter

func _ready():
	super._ready()
	SignalManager.main_quest_1_talk_to_guard.connect(drop_item)

func drop_item():
	var item = ItemManager.get_item("sword_v00")
	
	var floor_item : FloorItem = ResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	Global.current_map.floor_item.add_child(floor_item)
	floor_item.global_position = global_position + Vector2(16,0)
	floor_item.set_z_index(self.z_index)

