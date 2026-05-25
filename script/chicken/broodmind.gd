extends Node2D

@onready var host : chicken = get_parent().get_parent().get_parent()

func _process(delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		var areas = $Area2D.get_overlapping_bodies()
		for i in range(areas.size()):
			areas[i].state = host.state
			areas[i].randomlook.rotation = host.randomlook.rotation
