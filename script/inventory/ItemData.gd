extends Resource
class_name ItemData

@export var item_name : String
@export var item_icon : Texture2D
@export var item_modulate : Color
@export var item_size : Vector2i = Vector2i(1, 1)
@export var item_amount : int = 1

func get_description():
	return item_name
