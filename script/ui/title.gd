extends Control


func _on_button_pressed() -> void: #play button
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(20,20),0.6).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")
