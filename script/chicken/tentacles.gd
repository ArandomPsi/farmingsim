extends Line2D
@export var jiggle_segments := 12
@export var jiggle_damping := 0.9
@export var jiggle_gravity := Vector2(0, 0)
@export var jiggle_iterations := 4

var rope_points : PackedVector2Array = []
var rope_prev : PackedVector2Array = []

@export var endpos : Node2D

#yoinked from attack on chibi

func ropestuff():
	
	global_position = Vector2(0,0)
	
	if not visible:
		rope_points.clear()
		rope_prev.clear()
		clear_points()
		return
	
	var start_pos : Vector2 = get_parent().global_position
	var end_pos : Vector2 = endpos.global_position
	
	# Init rope once
	if rope_points.is_empty():
		for i in jiggle_segments:
			var t := float(i) / float(jiggle_segments - 1)
			var p := start_pos.lerp(end_pos, t)
			rope_points.append(p)
			rope_prev.append(p)
	
	# Jiggle integration
	var delta := get_physics_process_delta_time()
	
	for i in range(1, rope_points.size() - 1):
		var vel := (rope_points[i] - rope_prev[i]) * jiggle_damping
		rope_prev[i] = rope_points[i]
		rope_points[i] += vel + jiggle_gravity * delta * delta
	
	# Constraint solve
	var seg_len := start_pos.distance_to(end_pos) / (jiggle_segments - 1)
	
	for _k in jiggle_iterations:
		rope_points[0] = start_pos
		rope_points[rope_points.size() - 1] = end_pos
	
		for i in range(rope_points.size() - 1):
			var diff := rope_points[i + 1] - rope_points[i]
			var dist := diff.length()
			if dist == 0:
				continue
	
			var error := (dist - seg_len) / dist
			var offset := diff * 0.5 * error
	
			if i != 0:
				rope_points[i] += offset
			if i + 1 != rope_points.size() - 1:
				rope_points[i + 1] -= offset
	
	points = rope_points
