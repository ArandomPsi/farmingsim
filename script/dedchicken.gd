extends Node2D

var chickenstats : Dictionary = { #all stats can reach 100
	"size" : 67,
	"tenderness" : 67
}

func _ready() -> void:
	$GPUParticles2D.emitting = true
	var timer = get_tree().create_timer(5)
	await timer.timeout
	$GPUParticles2D.speed_scale = 0.0
