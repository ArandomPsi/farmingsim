extends Area2D

func _ready() -> void:
	for ie in range(2):
		await get_tree().process_frame
	
	var thingies = get_overlapping_areas()
	
	if thingies.size() > 0:
		for i in range(thingies):
			thingies[i].get_parent().queue_free()
	
	print(str(thingies))
	
