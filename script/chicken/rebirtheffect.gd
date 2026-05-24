extends Node2D
func _ready() -> void:
	#$wing1.position = Vector2(11,0)
	#$wing1.rotation = 0
	#$wing2.position = Vector2(-11,0)
	var tween = create_tween()
	$wing1.modulate.a = 0
	$wing2.modulate.a = 0
	$wing1.position = Vector2(31,3.0)
	$wing1.rotation_degrees = -130.2
	$wing2.position = Vector2(-28,3)
	$wing2.rotation_degrees = 135.2
	
	tween.tween_property($wing1,"modulate", Color(1,1,1,1), 0.4)
	tween.parallel().tween_property($wing2,"modulate", Color(1,1,1,1), 0.4)
	
	tween.parallel().tween_property($wing1,"position",Vector2(11,0), 0.9).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($wing2,"position",Vector2(-11,0), 0.9).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property($wing1,"rotation",0, 0.9).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($wing2,"rotation",0, 0.9).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property($wing1,"modulate", Color(1,1,1,0), 0.8)
	tween.parallel().tween_property($wing2,"modulate", Color(1,1,1,0), 0.8)
	
	await tween.finished
	queue_free()
	
