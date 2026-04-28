extends Node2D

var chickenstats : Dictionary = { #all stats can reach 100
	
}

var chickenvalue : int = 0

func _ready() -> void:
	$GPUParticles2D.emitting = true
	chickenvalue = pow(chickenstats["size"],1.2) + pow(chickenstats["tenderness"],1.4)
	var timer = get_tree().create_timer(5)
	await timer.timeout
	$GPUParticles2D.speed_scale = 0.0

func _process(delta: float) -> void:
	var in_range = global_position.distance_squared_to(global.playerpos) <= pow(30, 2)
	$Popup.visible = in_range
	$Popup.scale.x = -1 if scale.x < 0 else 1
	if Input.is_action_just_pressed("interact") and in_range:
		sell()

func sell():
	global.player.currency += chickenvalue
	queue_free()
