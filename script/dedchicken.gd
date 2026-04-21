extends Node2D

var chickenstats : Dictionary = { #all stats can reach 100
	
}

var chickenvalue : int = 0

func _ready() -> void:
	$GPUParticles2D.emitting = true
	chickenvalue = pow(chickenstats["size"],1.2) + pow(chickenstats["tenderness"],1.4)
	print(str(chickenvalue))
	var timer = get_tree().create_timer(5)
	await timer.timeout
	$GPUParticles2D.speed_scale = 0.0
