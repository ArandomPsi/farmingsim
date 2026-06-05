extends Node2D

@export var texture : Texture2D

func _ready() -> void:
	var b = preload("res://scenes/ui/minimapiconicon.tscn").instantiate()
	global.minimapthingy.add_child(b)
	b.node = get_parent()
	b.texture = texture
	
