extends TextureRect
class_name ShopSlot

@onready var lbl_quantity : Label = $Quantity
@onready var item : TextureRect = $Item

var item_id : String
var quantity

func _ready():
	lbl_quantity.text = str(quantity) if quantity > 1 else ""
	item.texture = ResourceManager.sprites[item_id]
