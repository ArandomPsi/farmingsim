extends GPUParticles2D #omg particles so late
func _ready() -> void:
	emitting = true
	await finished
	queue_free()
	
