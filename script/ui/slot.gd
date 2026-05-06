extends Panel

@onready var display : Sprite2D = $display

func update(item: invitem):
	if not item:
		display.visible = false
	else:
		display.visible = true
		display.texture = item.texture
