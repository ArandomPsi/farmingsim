extends mineable
func _ready() -> void:
	$sprite.material = $sprite.material.duplicate()
	$sprite.material.set_shader_parameter("amplitude",randf_range(0.35,0.49))
