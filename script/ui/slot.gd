extends Panel

@onready var display : Sprite2D = $display
@onready var amount : Label = $amount

@export var parent : Control
@export var slot_index : int = 0

var currentitem : invitem

func _ready() -> void:
	slot_index = get_index()

func update(item: invslot):
	if item == null or item.item == null:
		display.visible = false
		currentitem = null
		$amount.visible = false
		return
	display.visible = true
	display.texture = item.item.texture
	currentitem = item.item
	amount.text = str(item.amount)
	
	$amount.visible = item.item.stackable
	



#bru so much simplier
func _on_button_pressed() -> void:
	var inventory = parent.playerinventory.items
	var temp = inventory[slot_index]
	inventory[slot_index] = global.phantomitem
	global.phantomitem = temp
	parent.updateslots()
