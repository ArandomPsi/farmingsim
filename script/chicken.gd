extends CharacterBody2D
var size : float = 1
var speed : float = 1500

var state : int = 0 #idle, wander, gobble
var statetime : int = 0
var randomturning : float = 0

var currentfood : int = 100 #max food = 100
var currentwater : int = 100 #max water = 100
var updatetick : int = 0

@export var debug : bool = false


func _process(delta: float) -> void:
	
	if velocity.x > 0: $flip.scale.x = 1
	elif velocity.x < 0: $flip.scale.x = -1
	
	updatetick -= 1
	statetime -= 1
	
	if updatetick < 0:
		currentfood -= 1
		updatetick = randi_range(20,40)
	
	#random states
	if statetime < 1:
		state = randi_range(0,2)
		if state == 0:
			statetime = randi_range(60,300)
		elif state == 1:
			statetime = randi_range(30,500)
			$randomlook.rotation = randi_range(0,2*PI)
			randomturning = randi_range(-15,15)
		elif state == 2:
			statetime = randi_range(50,120)
			
	
	match state:
		0:
			idlestate()
		1:
			wanderstate(delta)
		2:
			gobblegobble()
	
	velocity *= 0.85
	
	move_and_slide()
	
	if debug:
		print(str(currentfood))
		print(str(updatetick))
	
	
	if not state == 2:
		animations()
	


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

func gobblegobble():
	$flip/sprite.play("peck")
	currentfood += 1
