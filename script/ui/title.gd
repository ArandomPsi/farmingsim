extends Control


func _on_button_pressed() -> void: #play button
	global.time = global.ingame_to_real_minute_duration * global.INITIAL_HOUR * 60
	global.days = 0
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(25,25),0.6).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")


func _process(delta: float) -> void:
	if get_global_mouse_position().x < 60:
		$idiotpanel.position.x = lerpf($idiotpanel.position.x,15,0.2)
	else:
		$idiotpanel.position.x = lerpf($idiotpanel.position.x,-430,0.2)
