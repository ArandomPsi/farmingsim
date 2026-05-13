extends Control

#no matrixs bc they hurt my head lowk
var textures : Array = [Texture2D]
var costs : Array = []
var descriptions : Array = []
var currentselection : int = 0
@onready var preview: Sprite2D = $preview



@onready var items = $ScrollContainer/VBoxContainer as VBoxContainer

func _ready() -> void:
	await get_tree().process_frame
	for i in range($ScrollContainer/VBoxContainer.get_child_count()):
		#set all of the variables here
		textures.push_back($ScrollContainer/VBoxContainer.get_child(i-1).texture)
		costs.push_back($ScrollContainer/VBoxContainer.get_child(i-1).costs)
		descriptions.push_back($ScrollContainer/VBoxContainer.get_child(i-1).description)
		$ScrollContainer/VBoxContainer.get_child(i).childcount = i
	


func updateshop():
	if currentselection < 0 or currentselection >= textures.size():
		return
	
	$cost.text = "cost - " + str(costs[currentselection])
	$info.text = descriptions[currentselection]
	


func _on_buy_pressed() -> void:
	if costs[currentselection] <= global.player.currency: #no stealing here dumbass
		global.player.currency -= costs[currentselection] #buy the item
		
		global.player.playerinventory.additem($ScrollContainer/VBoxContainer.get_child(currentselection).item) #add the item
		
	
