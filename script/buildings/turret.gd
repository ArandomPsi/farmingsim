extends mineable

@export var orbit_distance_x : float = 4.0
@export var orbit_distance_y : float = 2.0

var shotcooldown : int = 0

func _process(delta):
	
	shotcooldown -= 1
	var closest = getclosestbody()
	
	if closest:
		$targeter.look_at(closest.global_position)
		if shotcooldown < 1:
			brrrr()
			shotvfx()
			shotcooldown = 10
	else:
		$targeter.look_at(global.playerpos)
	
	$sprite/gun.position = Vector2(
		cos($targeter.rotation) * orbit_distance_x,
		sin($targeter.rotation) * orbit_distance_y
	)
	
	if $sprite/gun.position.y < 0.1:
		$sprite/gun.z_index = -1
	else:
		$sprite/gun.z_index = 1
	
	
	
	
	
	


func shotvfx():
	var b = preload("res://scenes/vfx/shot.tscn").instantiate()
	get_parent().add_child(b)
	b.position = $sprite/gun.global_position
	b.rotation = $targeter.rotation

func brrrr():
	var b = preload("res://scenes/player/bullet.tscn").instantiate()
	get_parent().add_child(b)
	b.position = $sprite/gun.global_position
	b.rotation = $targeter.rotation

func getclosestbody() -> Node2D:
	var bodies = $detector.get_overlapping_bodies()

	var closest : Node2D = null
	var closest_dist := INF

	for body in bodies:
		if body == self:
			continue
		var dist = global_position.distance_squared_to(
			body.global_position
		)

		if dist < closest_dist:
			closest_dist = dist
			closest = body

	return closest
