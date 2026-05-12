extends Control


@onready var playerinventory : inventory = preload("res://assets/inventoryresources/playerinventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()
var open : bool = false

@onready var player = get_parent().get_parent()

func _ready() -> void:
	playerinventory.update.connect(updateslots)
	updateslots()
	close()

func updateslots():

	for i in range(min(playerinventory.items.size(), slots.size())):
		slots[i].update(playerinventory.items[i])
	
	#bruuuh why does it keep breaking devworm? Am I just a bad coder? To be fair I'm more of a vfx artist
	for i in range(3):
	
		var slot = playerinventory.items[i]
	
		if slot != null and slot.item != null:
			player.weapons[i] = slot.item.name
		else:
			player.weapons[i] = ""

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
