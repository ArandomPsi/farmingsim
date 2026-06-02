extends Node2D
@export var guarding : Node2D

var velocity : Vector2
var attackframes : int = 0

func _process(delta: float) -> void:
	
	attackframes -= 1
	$attackbox/CollisionShape2D.disabled = attackframes < 1
	
	if is_instance_valid(guarding):
		
		if $Area2D.has_overlapping_bodies():
			var areas = $Area2D.get_overlapping_bodies()
			if not areas.is_empty():
				if not areas[0] == guarding:
					assault(areas[0])
		else:
			if position.distance_to(guarding.position) > 100:
				chase(guarding)
			else:
				idle()
	else:
		die()
	
	velocity *= pow(0.96, delta * 60.0)
	position += velocity * delta
	
	if velocity.x > 0:
		$sprite.scale.x = 5
	else:
		$sprite.scale.x = -5
	
	$sprite/shadow2.animation = $sprite.animation
	$sprite/shadow2.frame = $sprite.frame
	

func die():
	queue_free()

func idle():
	$sprite.play("idle")


func chase(node : Node2D):
	$sprite.play("walk")
	$looker.look_at(node.position)
	velocity += $looker.transform.x * 20

func assault(node : Node2D):
	if position.distance_to(node.global_position) > 20 and attackframes < 1:
		$sprite.play("walk")
		$looker.look_at(node.position)
		velocity += $looker.transform.x * 40
	else:
		$looker.look_at(node.position)
		velocity += $looker.transform.x * 10
		$sprite.play("attack")
		attackframes = 10
