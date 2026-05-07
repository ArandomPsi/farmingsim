extends Panel

@onready var display : Sprite2D = $display

@export var parent : Control
@export var slot_index : int = 0

var currentitem : invitem

func _ready() -> void:
	slot_index = get_index()

func update(item: invitem):
	if not item:
		display.visible = false
		currentitem = null
	else:
		display.visible = true
		display.texture = item.texture
		currentitem = item


func _on_button_pressed() -> void:
	var inventory = parent.playerinventory.items
	
	if global.phantomitem != null: #nothing there
		var temp = inventory[slot_index]
		inventory[slot_index] = global.phantomitem
		global.phantomitem = temp
	else: #picking up
		if inventory[slot_index] != null:
			global.phantomitem = inventory[slot_index]
			inventory[slot_index] = null
	
	parent.updateslots()
