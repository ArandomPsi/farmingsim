extends Sprite2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self,"self_modulate",Color(1,1,1,0),0.2)
	tween.parallel().tween_property($PointLight2D,"energy", 0.0,0.2)
	await tween.finished
	queue_free()
