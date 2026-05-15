extends Node2D
func _ready() -> void:
	for i in range(80):
		var timer = get_tree().create_timer(0.1) #takes 60 seconds to instakill
		await timer.timeout
		get_parent().damage(1)
	queue_free()
	
