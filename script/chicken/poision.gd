extends Node2D
func _ready() -> void:
	var timer = get_tree().create_timer(10) #takes 60 seconds to instakill
	await timer.timeout
	$attackbox/CollisionShape2D.disabled = false
	get_parent().damage(99999)
	queue_free()
