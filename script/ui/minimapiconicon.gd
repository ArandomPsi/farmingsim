extends Sprite2D
@export var node : Node2D
func _process(delta: float) -> void:
	if is_instance_valid(node):
		position = node.position
	else:
		queue_free()
