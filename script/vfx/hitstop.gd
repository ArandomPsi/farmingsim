extends Node
@export var time : float = 0.05
func _ready() -> void:
	Engine.time_scale = 0.25
	var timer = get_tree().create_timer(time,true,false,true)
	await timer.timeout
	Engine.time_scale = 1
