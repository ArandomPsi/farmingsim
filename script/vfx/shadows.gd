extends Node2D
@export var vertshadow : bool = false
func _process(delta: float) -> void:
	var angle = (global.truetime / 24.0) * TAU
	
	# shadow skew
	if not vertshadow:
		global_skew = sin(angle) * deg_to_rad(74.6)
	
	self_modulate.a = max(cos(angle - PI), 0.0)
