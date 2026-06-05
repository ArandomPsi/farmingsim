extends TextureRect

func _process(delta: float) -> void:
	visible = position.x < 1167
	if global.map_open:
		position.x = lerpf(position.x,958,0.15)
	else:
		position.x = lerpf(position.x,1167 + 20,0.15)
