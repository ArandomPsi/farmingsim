extends Control


@onready var playerinventory : inventory = preload("res://assets/inventoryresources/playerinventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()
var open : bool = false

@onready var player = get_parent().get_parent()

func _ready() -> void:
	updateslots()
	close()

func updateslots():
	for i in range(min(playerinventory.items.size(),slots.size())):
		slots[i].update(playerinventory.items[i])
	
	player.weapons[0] = playerinventory.items[0].name
	player.weapons[1] = playerinventory.items[1].name
	player.weapons[2] = playerinventory.items[2].name
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("openinventory"):
		if open:
			close()
		else:
			openinv()
	

func openinv():
	visible = true
	open = true

func close():
	visible = false
	open = false
