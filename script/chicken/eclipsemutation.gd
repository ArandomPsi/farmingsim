extends Node2D

func _process(delta: float) -> void:
	var areas = $Area2D.get_overlapping_bodies()
	if $Area2D.has_overlapping_bodies():
		for i in range(areas.size()):
			areas[i].velocity
