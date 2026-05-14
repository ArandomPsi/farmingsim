extends Node2D



func _ready() -> void:
	get_parent().hp *= randf_range(1,5)

func _process(delta: float) -> void:
	if not $Area2D.has_overlapping_bodies():
		$Timer.stop()
	elif $Timer.is_stopped():
		$Timer.start(0.2)
	



func _on_timer_timeout() -> void:
	$Timer.start(randf_range(1.0,2.0))
	if $Area2D.has_overlapping_bodies():
		var b = preload("res://scenes/chicken/spit.tscn").instantiate()
		get_tree().current_scene.add_child(b)
		b.position = global_position
		var targets = $Area2D.get_overlapping_bodies()
		b.look_at(targets[0].global_position)
