extends Node2D
var frames : int = 50
func _process(delta: float) -> void:
	frames -= 1
	if frames < 1:
		frames = randi_range(30,180)
		var b = preload("res://scenes/chicken/explosion.tscn").instantiate()
		b.global_position = global_position
		b.emitting = true
		get_tree().current_scene.add_child(b)
		
	
