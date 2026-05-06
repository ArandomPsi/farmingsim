extends PointLight2D
@export var time : float = 0.2
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self,"energy",0.0,time)
