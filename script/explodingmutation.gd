extends Node2D
var frames : int = 50
func _process(delta: float) -> void:
	frames -= 1
	if frames < 1:
		frames = randi_range(30,180)
		global.player.shakeframes += 10000 / position.distance_to(global.playerpos)
		print(global.player.shakeframes)
		var b = preload("res://scenes/chicken/explosion.tscn").instantiate()
		b.global_position = global_position
		get_tree().current_scene.add_child(b)
		
		
	
