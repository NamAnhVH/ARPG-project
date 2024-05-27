extends BreakableObject

func _ready():
	if !sprite:
		sprite = ResourceManager.breakable_pot_texture.pick_random()
	sprite2D.texture = sprite
