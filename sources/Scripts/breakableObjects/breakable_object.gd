extends StaticBody2D
class_name BreakableObject

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var sprite2D : Sprite2D = $Sprite2D


@export var item_drop_id : Array[String]
@export var sprite : Texture2D

func destory():
	drop_item()
	queue_free()

func drop_item():
	if !item_drop_id.is_empty():
		var item = ItemManager.get_item(item_drop_id.pick_random())
		var floor_item : FloorItem = ResourceManager.get_instance("floor_item")
		floor_item.item = item
		Global.current_map.floor_item.add_child(floor_item)
		floor_item.global_position = global_position + Vector2(5,5)
		floor_item.set_z_index(self.z_index)

func _on_hitbox_feature_damaged():
	hitbox.queue_free()
	animation.queue("break")
