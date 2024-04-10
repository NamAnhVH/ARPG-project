extends NonePlayableCharacter

@export var product : Array[Dictionary]

#func _ready():
	#SignalManager.set_shop.connect(open_shop)

func interact():
	super.interact()
	SignalManager.show_dialogue.emit("merchant", "start")

func open_shop(npc_name: String):
	if object_name == npc_name:
		SignalManager.shop_opened.emit(product)

func out_of_range():
	SignalManager.shop_closed.emit()
