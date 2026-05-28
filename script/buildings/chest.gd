extends mineable

@export var inv : inventory
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()
var open : bool = false

@onready var player = get_parent().get_parent()

@onready var hotbarslot1 = $NinePatchRect/GridContainer/slot
@onready var hotbarslot2 = $NinePatchRect/GridContainer/slot2
@onready var hotbarslot3 = $NinePatchRect/GridContainer/slot3

func _ready() -> void:
	inv = inv.duplicate()
	
	inv.update.connect(updateslots)
	


func _process(delta: float) -> void:
	if $chest.has_overlapping_bodies():
		$Label.visible = true
		if Input.is_action_just_pressed("interact"):
			global.player.showinventory #fix 
			$inventory.visible = true
		
	else:
		$Label.visible = false





func updateslots():

	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
	
	#bruuuh why does it keep breaking devworm? Am I just a bad coder? To be fair I'm more of a vfx artist
	
