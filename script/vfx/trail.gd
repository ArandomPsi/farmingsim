extends Line2D

var queue : Array
@export var maxsize : int = 67 #in pixels

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	
	if get_parent().get_parent().scale.x < 0:
		scale.x = -1
	else:
		scale.x = 1
	
	
	queue.push_front(get_parent().global_position)
	
	if queue.size() >= maxsize: queue.pop_back()
	
	updatepoints()
	

func updatepoints():
	clear_points()
	points = queue
