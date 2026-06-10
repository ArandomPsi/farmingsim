extends Node2D



func teleport():
	var b = preload("res://scenes/chicken/abracadabraeffect.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = global_position
	$RayCast2D.rotation_degrees = randi_range(0,360) #tau is 2 pi, the more you know
	$RayCast2D.force_raycast_update()
	
	#so that it doesn't go to (0,0)
	
	get_parent().position += $RayCast2D.target_position.x * $RayCast2D.global_transform.x
	
	
	get_parent().position.x = clamp(get_parent().position.x,20,6600)
	get_parent().position.y = clamp(get_parent().position.y,50,5450)
	
	b.look_at(get_parent().global_position) #cool effect
	

func _on_timer_timeout() -> void:
	teleport()
	if randi_range(1,5) == 1:
		$Timer.start(randi_range(5,10))
	else:
		$Timer.start(0.3)
