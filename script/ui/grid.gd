extends Sprite2D

func _process(delta: float) -> void:
	material.set_shader_parameter("offset",global.playerpos/ 20) 
