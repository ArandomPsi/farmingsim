extends Area2D
class_name chickenkiller


func _on_body_entered(body: Node2D) -> void:
	body.die()
