extends Node2D
var t : float

func _process(delta: float) -> void:
	t += delta
	
	$wing1.rotation = sin(t * 10)
	$wing2.rotation = -sin(t * 10)
	
