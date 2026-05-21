extends Node2D
var frames : int = 180
const SEP_TIME : float = 0.3
var timer : float = 0.0
var counter : int = 0
var target = null

func _ready() -> void:
	get_parent().hp *= randi_range(0.8, 5.0)
	

func _process(delta: float) -> void:
	var enemies = $enemydetector.get_overlapping_bodies()
	if enemies.size() > 0:
		frames -= 1
		if target == null:
			target = enemies.pick_random()
	if frames < 1:
		timer += delta
		if timer >= SEP_TIME:
			counter += 1
			var b = preload("res://scenes/chicken/daggerfeather.tscn").instantiate()
			b.global_position = global_position
			var angle = global_position.direction_to(target.global_position).angle()
			b.rotation = angle + randf_range(-PI / 2, PI / 2)
			get_tree().current_scene.add_child(b)
			timer = 0
		if counter >= 3:
			frames = randi_range(90,270)
			counter = 0
			timer = 0
			target = null
		
		
		
	
 
