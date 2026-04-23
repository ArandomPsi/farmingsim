extends Line2D

var tetheredbody : Node2D

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	clear_points()
	add_point(global.playerpos)
	add_point(tetheredbody.position)
	
