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
	var n = helditem.name if not helditem.name == "diamond" else "rock"
	if hp <= 0:
		global.instance_removed.emit(n, position)
		queue_free()

func _process(delta: float) -> void:
	$sprite.position.x = lerpf($sprite.position.x, 0, 0.18)
	if $Area2D.has_overlapping_bodies():
		queue_free()
	
	

func shake():
	for i in range(8):
		$sprite.position.x = randi_range(-20,20)
		await get_tree().create_timer(1/3)
