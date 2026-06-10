extends Node2D



func _on_timer_timeout() -> void:
	var bodies : Array = $Area2D.get_overlapping_bodies()
	for i in range(bodies.size()):
		bodies[i].hp += 1
		
