extends Node2D

@export var presetlocations : PackedVector2Array

func _on_timer_timeout() -> void:
	position = presetlocations[randi_range(0,9)]
	
	if position.distance_to(global.playerpos) < 1200: #no spawning on player
		$Timer.start(randi_range(2,5))
		return
	else:
		$Timer.start(randi_range(80,200))
	
	for i in range(randi_range(2,20)):
		var b = preload("res://scenes/monsters/wolf.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		
		if i == 0:
			b.alpha = true
		await get_tree().process_frame
	
	print("spawned")
	
	
	
