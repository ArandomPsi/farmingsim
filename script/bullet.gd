extends Sprite2D
var speed : int = 2500
var frames : int = 120
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	if frames < 1:
		queue_free()
	
	frames -= 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.die()
	queue_free()
