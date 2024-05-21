extends Merchant

func interact():
	Global.npc_name = object_name
	SignalManager.show_dialogue.emit("weapon_shopkeeper", "start")

func out_of_range():
	if Global.is_shop_opened:
		SignalManager.shop_closed.emit()
	elif Global.is_sell_item_opened:
		SignalManager.sell_item_closed.emit()
