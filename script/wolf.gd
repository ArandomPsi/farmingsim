extends CharacterBody2D

var speed : float = 1500
var friciton : float = 0.95

var state : int = 0 #idle, wander, sleep, chase
var statetime : int = 0

var randomturning : float = 0

func _process(delta: float) -> void:
	
	if velocity.x > 0: $flip.scale.x = 1
	elif velocity.x < 0: $flip.scale.x = -1
	
	statetime -= 1
	if statetime < 1:
		updatestates()
	else:
		handlestates(delta)
	
	velocity *= friciton
	
	move_and_slide()
	
	animations()
	


func updatestates():
	
	
	if $Area2D.has_overlapping_bodies():
		state = 3
		statetime = 200
	else:
		state = randi_range(0,2)
		statetime = randi_range(160,360)
		
		if state == 1:
			$randomlook.rotation = randi_range(0,2*PI)
			randomturning = randi_range(-15,15)
		
	
	


func handlestates(delta):
	
	match state:
		0:
			idlestate()
		1:
			wanderstate(delta)
		2:
			idlestate() #for now
		3:
			omnomnom(delta)
		
		
	
	
	

func idlestate():
	if randi_range(1,20) == 1: #random turning
		velocity.x = randi_range(1,-1)


func wanderstate(delta):
	velocity += $randomlook.transform.x * speed * delta
	
	$randomlook.rotation_degrees += randomturning * delta
	
	if randf() < 0.02:
		state = 0
		statetime = randi_range(30,120)

func omnomnom(delta):
	var dinnermenu = $Area2D.get_overlapping_bodies()
	if dinnermenu.is_empty():
		statetime = 0
		return
	$randomlook.look_at(get_closest_body(dinnermenu).global_position)
	velocity += speed * $randomlook.transform.x * delta
	
	


func animations():
	if round(velocity/10) == Vector2.ZERO:
		$flip/sprite.play("idle")
	else:
		$flip/sprite.play("run")

func get_closest_body(array) -> Node2D:
	var bodies = array
	
	var closest : Node2D = null
	var closest_dist := INF
	
	for b in bodies:
		if not b.is_in_group("chicken"):
			continue
		
		if b == self:
			continue
		
		var dist = global_position.distance_to(b.global_position)
		
		if dist < closest_dist:
			closest_dist = dist
			closest = b
	
	return closest


func _on_chickenkiller_body_entered(body: Node2D) -> void:
	body.die()
	velocity *= -1.5
