extends Node2D

var childnum : int = 0

func _ready() -> void:
	get_parent().chickenstats["size"] += randf_range(1.2, 2.4) * childnum * randi_range(1, 4)
	get_parent().chickenstats["tenderness"] += randf_range(1.1, 1.6) * childnum
	get_parent().chickenstats["strength"] += randf_range(1.5,3) * childnum * randi_range(2, 3)
	get_parent().hp -= get_parent().chickenstats["strength"] / childnum
	get_parent().chickenmutations[get_parent().chickenmutations.find("russiandoll" + str(childnum - 1))] = "russiandoll" + str(childnum)
