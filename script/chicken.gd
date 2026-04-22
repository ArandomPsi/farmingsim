extends CharacterBody2D
var size : float = 1
var speed : float = 1500

var state : int = 0 #idle, wander, gobble
var statetime : int = 0
var randomturning : float = 0

var currentfood : int = 100 #max food = 100
var currentwater : int = 100 #max water = 100
var lust : int = 10
var updatetick : int = 0

@export var debug : bool = false

var chickenstats : Dictionary = { #all stats can reach 100
	"size": 0,
	"tenderness": 0
}

var partnerchickenstats : Dictionary = {} #for mating purposes

func _ready() -> void:
	chickenstats = chickenstats.duplicate()
	chickenstats["size"] *= randf_range(0.8,1.2)
	chickenstats["tenderness"] *= randf_range(0.8,1.2)
	add_to_group("chicken")
	scale *= max(chickenstats.size / 100, 1)

func _process(delta: float) -> void:
	
	if velocity.x > 0: $flip.scale.x = 1
	elif velocity.x < 0: $flip.scale.x = -1
	
	handlestates()
	
	match state:
		0:
			idlestate()
		1:
			wanderstate(delta)
		2:
			gobblegobble()
		3:
			goonstate(delta)
	
	velocity *= 0.85
	
	move_and_slide()
	
	if debug:
		print(str(currentfood))
		print(str(lust))
		print(str(updatetick))
	
	
	if not state == 2:
		animations()
	


func handlestates():
	updatetick -= 1
	statetime -= 1
	
	if updatetick < 0:
		currentfood -= 1
		lust -= 1
		updatetick = randi_range(20,40)
		if lust < 0:
			if randi_range(1,2) == 1: #temptation
				statetime = 600
				state = 3
			else:
				lust = randi_range(10,60)
	
	#random states
	if statetime < 1:
		
		if state == 3:
			layegg()
		
		state = randi_range(0,2)
		if state == 0:
			statetime = randi_range(60,300)
		elif state == 1:
			statetime = randi_range(30,500)
			$randomlook.rotation = randi_range(0,2*PI)
			randomturning = randi_range(-15,15)
		elif state == 2:
			statetime = randi_range(50,120)
			


func animations():
	if round(velocity/10) == Vector2.ZERO:
		$flip/sprite.play("idle")
	else:
		$flip/sprite.play("walk")


func idlestate():
	if randi_range(1,20) == 1: #random turning
		velocity.x = randi_range(1,-1)

func wanderstate(delta):
	velocity += $randomlook.transform.x * speed * delta
	
	$randomlook.rotation_degrees += randomturning * delta
	
	if randf() < 0.02:
		state = 0
		statetime = randi_range(30,120)

func goonstate(delta):
	
	print(str(get_closest_chicken().global_position))
	$suslook.look_at(get_closest_chicken().global_position)
	
	if position.distance_to(get_closest_chicken().global_position) < 20:
		get_closest_chicken().state = 3
		get_closest_chicken().statetime = statetime
		partnerchickenstats = get_closest_chicken().chickenstats
	else:
		velocity += $suslook.transform.x * speed * delta * 1.5


func layegg():
	var b = load("res://scenes/egg.tscn").instantiate()
	b.chickenstats = average_stats(chickenstats,partnerchickenstats)
	get_parent().add_child(b)
	b.position = position + Vector2(randf_range(-15,15),randf_range(-15,15))


func gobblegobble():
	$flip/sprite.play("peck")
	currentfood += 1

func die():
	var b = load("res://scenes/dedchicken.tscn").instantiate()
	b.chickenstats = chickenstats.duplicate()
	get_parent().add_child(b)
	b.position = position
	b.scale.x = $flip.scale.x
	
	queue_free()


func get_closest_chicken() -> Node2D:
	var bodies = $chickendetector.get_overlapping_bodies()
	
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

func average_stats(a: Dictionary, b: Dictionary) -> Dictionary:
	var result := {}
	
	for key in a.keys():
		result[key] = (a[key] + b[key]) * 0.5
	
	return result


func bounce(body: Node2D) -> void:
	$suslook.look_at(body.global_position)
	velocity = $suslook.transform.x * -300
