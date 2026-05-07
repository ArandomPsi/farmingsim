extends Sprite2D

func _process(delta: float) -> void:
	visible = not global.phantomitem == null
	if visible:
		texture = global.phantomitem.texture
		global_position = get_global_mouse_position()
