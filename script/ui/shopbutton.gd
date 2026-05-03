extends Button

@export var texture : String = "res://assets/playerstuff/coin.png"
@export var costs : int = 67


@export var childcount : int = 0

@export var description : String = "blah blah blah"

@onready var shop = get_parent().get_parent().get_parent()

func _ready() -> void:
	pressed.connect(boop)


func boop():
	shop.currentselection = childcount
	shop.updateshop()
