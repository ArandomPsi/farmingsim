extends Node2D
func _process(delta: float) -> void:
	position = -global.playerpos * scale.x
