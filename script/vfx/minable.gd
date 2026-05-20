extends Node2D
class_name mineable
@export var hp : int = 5
@export var helditem : invitem
func getmined():
	hp -= 1
	var b = preload("res://scenes/vfx/breakpar.tscn").instantiate()
	b.texture = helditem.texture
	get_parent().add_child(b)
	b.position = position
	if hp < 0:
		queue_free()

func _process(delta: float) -> void:
	$sprite.position.x = lerpf($sprite.position.x, 0, 0.18)

func shake():
	for i in range(8):
		$sprite.position.x = randi_range(-20,20)
		await get_tree().create_timer(1/3)
