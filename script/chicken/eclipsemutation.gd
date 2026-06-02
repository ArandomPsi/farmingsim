extends Node2D

func _process(delta: float) -> void:
	var areas = $Area2D.get_overlapping_bodies()
	if $Area2D.has_overlapping_bodies():
		for i in range(areas.size()):
			$looker.look_at(areas[i].global_position)
			if not areas[i] == get_parent():
				areas[i].velocity += $looker.transform.x * -900 * delta
			
	
