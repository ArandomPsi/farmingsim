extends Panel
@onready var sprite = $sprite as Sprite2D
@export var slot : int = 0



func _process(delta: float) -> void:
	if global.player.weapons[slot] != null:
		$sprite.set_texture(global.player.weapons[slot].texture)
	else:
		sprite.texture = null
