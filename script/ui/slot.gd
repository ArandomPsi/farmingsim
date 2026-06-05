extends Panel

@onready var display : Sprite2D = $display
@onready var amount : Label = $amount

@export var parent : Node
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
	
	
	
	
func _process(delta: float) -> void:
	if $Button.is_hovered():
		scale.x = lerpf(scale.x,1.2,0.3)
		scale.y = lerpf(scale.y,1.2,0.3)
	else:
		scale.x = lerpf(scale.x,1.0,0.3)
		scale.y = lerpf(scale.y,1.0,0.3)


#bru so much simplier
func _on_button_pressed() -> void:
	var inventory = parent.inv.items
	var temp = inventory[slot_index]
	inventory[slot_index] = global.phantomitem
	global.phantomitem = temp
	parent.updateslots()
	scale = Vector2(1.5,1.5)
	var b = load("res://scenes/sfx/pop.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	
	
