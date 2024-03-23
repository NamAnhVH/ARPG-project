extends HBoxContainer
class_name ShopSlotContainer

@onready var lbl_price : Label = $Price

var slot : ShopSlot
var item_id : String
var price : int
var quantity : int

func _ready():
	lbl_price.text = str(price)
	slot = ResourceManager.get_instance("shop_slot")
	slot.item_id = item_id
	slot.quantity = quantity
	add_child(slot)

