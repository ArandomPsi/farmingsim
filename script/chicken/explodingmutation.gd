extends Node2D
var frames : int = 50

func _ready() -> void:
	get_parent().hp *= randi_range(6, 30)
	get_parent().chickenstats["explosiveness"] = randi_range(50, 100)

func _process(delta: float) -> void:
	frames -= 1
	if frames < 1:
		frames = randi_range(30,180)
		global.player.shakeframes += 10000 / position.distance_to(global.playerpos)
		var b = preload("res://scenes/chicken/explosion.tscn").instantiate()
		b.global_position = global_position
		get_tree().current_scene.add_child(b)
		
		
	
 
