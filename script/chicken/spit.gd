extends Node2D
var frames : int = 0

func _process(delta: float) -> void:
	position += transform.x * 600 * delta
	if frames > 60:
		queue_free()



func _on_attackbox_body_entered(_body: Node2D) -> void:
	await get_tree().process_frame
	queue_free()
