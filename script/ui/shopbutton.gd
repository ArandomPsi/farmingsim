extends Button

var texture : Texture2D = preload("res://assets/playerstuff/coin.png")

@export var item : invitem
@export var costs : int = 67


@export var childcount : int = 0

@export_multiline var description : String = "blah blah blah"

@onready var shop = get_parent().get_parent().get_parent()

func _ready() -> void:
	texture = item.texture
	pressed.connect(boop)


func boop():
	shop.currentselection = childcount
	shop.preview.texture = texture
	shop.updateshop()
