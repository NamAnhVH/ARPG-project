extends NonePlayableCharacter

@export var product : Array[Dictionary] = [{"item_id": "", "price": 1, "quantity": 1}]

func _ready():
	super._ready()
	SignalManager.set_shop.connect(open_shop)

func interact():
	Global.npc_name = object_name
	SignalManager.show_dialogue.emit("merchant", "start")

func open_shop(npc_name: String):
	if object_name == npc_name:
		SignalManager.shop_opened.emit(product)

func out_of_range():
	if Global.is_shop_opened:
		SignalManager.shop_closed.emit()
	elif Global.is_upgrade_opened:
		SignalManager.upgrade_closed.emit()
	elif Global.is_sell_item_opened:
		SignalManager.sell_item_closed.emit()
