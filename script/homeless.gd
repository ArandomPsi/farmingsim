extends CharacterBody2D

var speed : float = 650
var friciton : float = 0.98

var state : int = 0 #idle, wander, sleep, chase
var statetime : int = 0

var randomturning : float = 0

var hp : int = 15

var jumpingplayer : bool = false

var attackanimframes : int = 0


@export var alpha : bool = false

func _ready() -> void:
	if alpha:
		speed *= 1.2
		hp *= 4
		scale *= 1.25


func _process(delta: float) -> void:
	
	if velocity.x > 0: $flip.scale.x = 1
	elif velocity.x < 0: $flip.scale.x = -1
	
	statetime -= 1
	attackanimframes -= 1
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
	if not jumpingplayer:
		var c = get_closest_body(dinnermenu)
		if c == null:
			statetime = 0
			return
		else:
			$randomlook.look_at(c.position)
	else:
		
		$randomlook.look_at(global.playerpos)
	velocity += speed * $randomlook.transform.x * delta
	
	


func animations():
	if attackanimframes > 1:
		$flip/sprite.play("attack")
	else:
		if round(velocity/10) == Vector2.ZERO:
			$flip/sprite.play("idle")
		else:
			
			$flip/sprite.play("run")

func get_closest_body(array) -> Node2D:
	var bodies = array
	
	var closest : Node2D = null
	var closest_dist := INF
	
	for b in bodies:
		
		
		if b in [self, global.player]:
			continue
		
		var dist = global_position.distance_to(b.global_position)
		
		if dist < closest_dist:
			closest_dist = dist
			closest = b
	
	return closest


func _on_chickenkiller_body_entered(body: Node2D) -> void:
	body.gethit(1)
	attackanimframes = 20
	velocity *= -1.5
	if hp < 6:
		hp += 1 #can gain up to 12 hp

func gethit(amount):
	hp -= amount
	
	if hp < 1:
		var b = preload("res://scenes/monsters/dedhomeless.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		scale.x = $flip.scale.x
		queue_free()
	else:
		var b = load("res://scenes/vfx/bloodspray.tscn").instantiate()
		b.position = global_position
		get_parent().add_child(b)


func bounce(body: Node2D) -> void:
	var randomlookrota = $randomlook.rotation
	$randomlook.look_at(body.global_position)
	velocity = -$randomlook.transform.x * speed/4
	$randomlook.rotation = randomlookrota


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
