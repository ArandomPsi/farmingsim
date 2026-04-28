extends CharacterBody2D
var size : float = 1
var speed : float = 1500

var state : int = 0 #idle, wander, gobble
var statetime : int = 0
var randomturning : float = 0

var currentfood : int = 100 #max food = 100
var currentwater : int = 100 #max water = 100
var lust : int = 200
var dominant : bool = false #laying one egg only
var updatetick : int = 0

@export var tethered : bool = false

@export var debug : bool = false

var ropecrash = null
var nearestcoop = null

@export var mutations : PackedStringArray
@export var hp : int = 1


var chickenstats : Dictionary = { #all stats can reach 100
	"size": randi_range(1,20),
	"tenderness": randi_range(1,20)
}

var partnerchickenstats : Dictionary = {} #for mating purposes

func _ready() -> void:
	chickenstats = chickenstats.duplicate()
	chickenstats["size"] *= randf_range(0.8,1.2)
	chickenstats["tenderness"] *= randf_range(0.8,1.2)
	add_to_group("chicken")
	scale *= max(chickenstats.size / 100, 1)
	partnerchickenstats.clear()
	
	if not mutations.is_empty(): #mutations make chicken naturally tankier
		hp *= randf_range(6,30)
	
	

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
		4:
			chasestate(nearestcoop.global_position,delta)
	
	if not state == 3:
		$flip/sprite/heartpar.emitting = false
		dominant = false
	
	
	
	velocity *= 0.85
	
	if tethered and position.distance_to(global.playerpos) > 200:
		$suslook.look_at(global.playerpos)
		velocity += $suslook.transform.x * 100
	
	
	move_and_slide()
	
	if debug:
		print(str(currentfood))
		print(str(lust))
		print(str(updatetick))
	
	
	if not state == 2:
		animations()
	
	updatestats()
	
	if global_position.distance_squared_to(get_global_mouse_position()) <= pow(30, 2):
		$stats.visible = true # if mouse is hovering over chicken, show stats
	else:
		$stats.visible = false
	
	if $hider.has_overlapping_areas():
		visible = false
	else:
		visible = true
	
	
	


func handlestates():
	updatetick -= 1
	statetime -= 1
	
	if updatetick < 0:
		currentfood -= 1
		lust -= 1
		updatetick = randi_range(20,40)
		if lust < 0:
			if randi_range(1,8) == 1: #temptation
				dominant = true #they are the rapist in this situation
				statetime = 600
				state = 3
			else:
				lust = randi_range(10,60)
	
	#random states
	if statetime < 1:
		
		if state == 3:
			if not partnerchickenstats.is_empty():
				layegg()
			state = 1 #run away after
		elif global.isnight:
			var coops = $coopchecker.get_overlapping_areas()
			if not coops.is_empty():
				state = 4
				statetime = 300
				nearestcoop = coops[0]
			else:
				state = 1
				statetime = randi_range(30,500)
				$randomlook.rotation = randi_range(0,2*PI)
				randomturning = randi_range(-15,15)
		else:
			state = randi_range(0,2)
		
		if state == 0:
			statetime = randi_range(60,300)
		elif state == 1:
			statetime = randi_range(30,500)
			$randomlook.rotation = randi_range(0,2*PI)
			randomturning = randi_range(-15,15)
		elif state == 2:
			statetime = randi_range(50,120)
	
	if mutations.has("terrorist"): #they always run towards the nearest chickens
		state = 3
		dominant = true
		statetime = 600
		state = 3
	
	


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
	
	var cc = get_closest_chicken()
	if is_instance_valid(cc):
		$suslook.look_at(cc.global_position)
	
		if position.distance_to(cc.global_position) < 20:
			cc.state = 3
			cc.statetime = statetime
			partnerchickenstats = cc.chickenstats.duplicate()
		else:
			velocity += $suslook.transform.x * speed * delta * 1.5
			$flip/sprite/heartpar.emitting = true

func chasestate(targetposition : Vector2, delta):
	velocity += $randomlook.transform.x * speed * delta
	$randomlook.look_at(targetposition)


func layegg():
	if not partnerchickenstats.is_empty() and dominant: #domininat is the one who provoked the pound town
		var b = load("res://scenes/egg.tscn").instantiate()
		b.chickenstats = average_stats(chickenstats,partnerchickenstats)
		partnerchickenstats.clear()
		get_parent().add_child(b)
		b.position = position + Vector2(randf_range(-15,15),randf_range(-15,15))

func updatestats():
	$stats/Label.text = "chicken stats: \n size - " + str(round(chickenstats["size"])) + "\n tenderness - " + str(round(chickenstats["tenderness"]))

func gobblegobble():
	$flip/sprite.play("peck")
	currentfood += 1

func die():
	hp -= 1
	if hp < 1:
		var b = load("res://scenes/dedchicken.tscn").instantiate()
		b.chickenstats = chickenstats.duplicate() #so that babies don't have empty dictionaries and stuff
		if is_instance_valid(ropecrash):
			ropecrash.queue_free()
		get_parent().add_child(b)
		b.position = position
		b.scale.x = $flip.scale.x
		b.chickenvalue *= mutations.size() + 1
		queue_free()
	else:
		var b = load("res://scenes/vfx/bloodspray.tscn").instantiate()
		b.position = global_position
		get_parent().add_child(b)
		print("added")


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

func rememberrope(rope):
	ropecrash = rope
