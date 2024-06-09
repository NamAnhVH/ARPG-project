extends Dungeon

@onready var gremlin : Boss = $Enemies/BossGremlin
@onready var stone_drop : Node2D = $StoneDrop

func _ready():
	gremlin.stone_drop.connect(_on_stone_drop)

func _on_area_2d_body_entered(body):
	super._on_area_2d_body_entered(body)
	if is_instance_valid(gremlin):
		gremlin._on_detect_area_body_entered(body)
	
func _on_area_2d_body_exited(body):
	if is_instance_valid(gremlin):
		gremlin.is_player_outside_area()

func _on_stone_drop():
	for i in range(20):
		var x = randi_range(20, 450)
		var y = randi_range(20, 450)
		var stone : StoneDrop = ResourceManager.get_instance("stone_drop")
		stone.position = Vector2(x, y)
		stone.damage_amount = gremlin.damage_amount
		stone_drop.add_child(stone)
