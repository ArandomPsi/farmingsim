extends Sprite2D

func _process(delta: float) -> void:
	visible = not global.phantomitem == null
	if visible:
		if not is_instance_valid(global.phantomitem.item): visible = false;return
		texture = global.phantomitem.item.texture
		global_position = get_global_mouse_position()
