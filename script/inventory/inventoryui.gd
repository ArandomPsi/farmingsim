extends Control


@onready var playerinventory : inventory = preload("res://assets/inventoryresources/playerinventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()
var open : bool = false

@onready var player = get_parent().get_parent()

@onready var hotbarslot1 = $NinePatchRect/GridContainer/slot
@onready var hotbarslot2 = $NinePatchRect/GridContainer/slot2
@onready var hotbarslot3 = $NinePatchRect/GridContainer/slot3

func _ready() -> void:
	playerinventory.update.connect(updateslots)
	updateslots()
	close()

func updateslots():

	for i in range(min(playerinventory.items.size(), slots.size())):
		slots[i].update(playerinventory.items[i])
	
	#bruuuh why does it keep breaking devworm? Am I just a bad coder? To be fair I'm more of a vfx artist
	

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
