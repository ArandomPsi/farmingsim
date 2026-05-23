extends Node2D
var velocity : Vector2

var speed : float = 150

@export var ogpos : Vector2


func _process(delta: float) -> void:
	if global_position.distance_to(get_parent().get_parent().global_position) > 100:
		global_position = get_parent().get_parent().global_position + ogpos * 2
	
	
