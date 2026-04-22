extends Node2D
var chickenstats : Dictionary = {
	"size" : randf_range(1,20),
	"tenderness" : randf_range(1,20)
}
var hatchtime : float = chickenstats.size * 0.85

func _ready() -> void:
	chickenstats["size"] *= randf_range(0.8,1.5)
	chickenstats["tenderness"] *= randf_range(0.8,1.5)
	await get_tree().create_timer(hatchtime).timeout
	hatch()

func hatch():
	var b = preload("res://scenes/chicken.tscn").instantiate()
	b.global_position = global_position
	b.chickenstats = chickenstats
	get_tree().current_scene.add_child(b)
	queue_free()
