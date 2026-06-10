extends Node2D

@export var texture : Texture2D

func _ready() -> void:
	if is_instance_valid(global.minimapthingy):
		var b = preload("res://scenes/ui/minimapiconicon.tscn").instantiate()
		global.minimapthingy.add_child(b)
		b.node = get_parent()
		b.texture = texture
	
