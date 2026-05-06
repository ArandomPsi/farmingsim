extends Sprite2D
var speed : int = 2500
var frames : int = 120
var damage : int = 1
func _process(delta: float) -> void:
	$Area2D.damage = damage
	position += transform.x * speed * delta
	if frames < 1:
		queue_free()
	
	frames -= 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	body.gethit(damage)
	createhiteffect()
	queue_free()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	body.damage(damage)
	createhiteffect()
	queue_free()

func createhiteffect():
	var b = preload("res://scenes/vfx/hiteffects.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position
	b.rotation = rotation
	b.scale.x  *= damage
