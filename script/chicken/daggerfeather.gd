extends Node2D

var speed : float = 350
var frames : int = 30

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	speed *= 0.98
	if speed <= 100:
		queue_free()
		
func create_hit_effect():
	pass
	#if there's a feathers fluffing type animation (if yk what i'm talking about) where the feathers poof everywhere then we can add this i guess
