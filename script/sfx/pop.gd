extends AudioStreamPlayer

func _ready() -> void:
	pitch_scale *= randf_range(0.9,1.2)

func _on_finished() -> void:
	queue_free()
