extends Node2D

func _ready() -> void:
	await $AnimatedSprite2D.animation_finished
	queue_free()
