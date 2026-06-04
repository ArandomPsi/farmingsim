extends WorldEnvironment

func _process(delta: float) -> void:
	environment.glow_enabled = global.bloom
