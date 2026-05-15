extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	var b = preload("res://scenes/chicken/poision.tscn").instantiate()
	body.add_child(b)
	
