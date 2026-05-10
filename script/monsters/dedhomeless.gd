extends Node2D

func _ready() -> void:
	var b = preload("res://scenes/vfx/bloodspray.tscn").instantiate()
	get_parent().add_child(b)
	await $AnimatedSprite2D.animation_finished
	queue_free()
