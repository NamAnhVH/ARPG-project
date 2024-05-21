extends Merchant

func interact():
	Global.npc_name = object_name
	SignalManager.show_dialogue.emit("blacksmith", "start")
