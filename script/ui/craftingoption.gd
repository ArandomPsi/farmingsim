extends Panel
@export var item : invitem

@export var prerequisite1 : invitem
@export var prerequisite1amount : int = 1
@export var prerequisite2 : invitem
@export var prerequisite2amount : int = 1
@export var desc : String


var selected : bool = false

func _ready() -> void:
	if not item == null:
		$prerequisites.text = desc
		$Label.text = item.name
		$Sprite2D.texture = item.texture

func _process(delta: float) -> void:
	selected = $Button.is_hovered()
	$prerequisites.visible = selected
	
	if selected:
		offset_left = lerpf(offset_left,-50,0.2)
	else:
		offset_left = lerpf(offset_left,0,0.2)


func pressed() -> void:
	if global.player.playerinventory.inventoryhas(prerequisite1, prerequisite1amount) and global.player.playerinventory.inventoryhas(prerequisite2, prerequisite2amount):
		global.player.playerinventory.additem(item)
		global.player.playerinventory.removeitem(prerequisite1,prerequisite1amount)
		global.player.playerinventory.removeitem(prerequisite2,prerequisite2amount)
	
