extends Panel

#no matrixs bc they hurt my head lowk
var textures : Array = []
var costs : Array = []
var descriptions : Array = []
var currentselection : int = 0


@onready var items = $ScrollContainer/VBoxContainer as VBoxContainer

func _ready() -> void:
	for i in range($ScrollContainer/VBoxContainer.get_child_count()):
		#set all of the variables here
		textures.push_back(load($ScrollContainer/VBoxContainer.get_child(i-1).texture))
		costs.push_back($ScrollContainer/VBoxContainer.get_child(i-1).costs)
		descriptions.push_back($ScrollContainer/VBoxContainer.get_child(i-1).description)
		$ScrollContainer/VBoxContainer.get_child(i).childcount = i
	print(str(textures))


func updateshop():
	if currentselection < 0 or currentselection >= textures.size():
		return
	
	$preview.texture = textures[currentselection+1]
	$cost.text = "cost - " + str(costs[currentselection + 1])
	$info.text = descriptions[currentselection + 1]
	print("yes")
