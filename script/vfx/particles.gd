extends GPUParticles2D #omg particles so late
func _ready() -> void:
	await finished
	queue_free()
	print("yes")
