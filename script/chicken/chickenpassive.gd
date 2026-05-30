extends chicken

const STATE_IDLE = 0
const STATE_WANDER = 1
const STATE_EAT = 2
const STATE_MATE = 3
const STATE_COOP = 4
const STATE_RUN = 5

@onready var randomlook = $randomlook as Node2D


func _process(delta: float) -> void:
	handle_states()
	handle_behavior(delta)
	handle_movement(delta)
	handle_animation()
	handle_visuals()
	handle_ui()

	move_and_slide()


func handle_behavior(delta):
	match state:
		STATE_IDLE:
			idlestate()
	
		STATE_WANDER:
			wanderstate(delta)
	
		STATE_EAT:
			gobblegobble()
		
		STATE_MATE:
			goonstate(delta)
	
		STATE_COOP:
			if is_instance_valid(nearestcoop):
				chasestate(nearestcoop.global_position, delta)
		
		STATE_RUN:
			corre(delta)


func handle_states():
	updatetick -= 1
	statetime -= 1
	
	# food ans stuff
	if updatetick < 0:
		currentfood -= 1
		lust -= 1
		updatetick = randi_range(20, 40)
	
	#UUUUHHH
	if chickenmutations.has("exploding"):
		dominant = true
		
		if state != STATE_MATE:
			state = STATE_MATE
			statetime = 600
	
	#THe dark urge :p
	elif lust < 0:
		if randi_range(1, 4) == 1:
			dominant = true
			state = STATE_MATE
			statetime = 600
		else:
			lust = randi_range(60, 80)
	
	
	
	if statetime < 1:
	
		#euphoria stuff
		if state == STATE_MATE:
			if not partnerchickenstats.is_empty():
				layegg()
			state = STATE_WANDER
		#I sleep
		elif global.isnight:
			var coops = $coopchecker.get_overlapping_areas()
			if not coops.is_empty():
				state = STATE_COOP
				statetime = 300
				nearestcoop = get_nearest_area(coops)
			else:
				start_wander()
		#normal
		else:
			state = randi_range(0, 2)
			match state:
				STATE_IDLE:
					statetime = randi_range(60, 300)
				STATE_WANDER:
					start_wander()
				STATE_EAT:
					statetime = randi_range(50, 120)


func start_wander():
	state = STATE_WANDER
	statetime = randi_range(30, 500)

	$randomlook.rotation = randf_range(0, TAU)
	randomturning = randf_range(-15, 15)


func handle_movement(delta):
	velocity *= pow(0.9, delta * 60.0)
	velocity = velocity.limit_length(speed * 2)

	# tether pull
	if tethered and position.distance_to(global.playerpos) > 200:
		$suslook.look_at(global.playerpos)
		velocity += $suslook.transform.x * 100


func handle_animation():
	if state == STATE_EAT:
		return

	if velocity.length_squared() < 25:
		$flip/sprite.play("idle")
	else:
		$flip/sprite.play("walk")
	
	$flip/sprite/shadow2.animation = $flip/sprite.animation
	$flip/sprite/shadow2.frame = $flip/sprite.frame

	if velocity.x > 0:
		$flip.scale.x = 1
	elif velocity.x < 0:
		$flip.scale.x = -1
	
	$flip/sprite/shadow2.animation = $flip/sprite.animation
	$flip/sprite/shadow2.frame = $flip/sprite.frame
	

func handle_visuals():
	# mating hearts
	if state == STATE_MATE:
		$flip/sprite/heartpar.emitting = true
	else:
		$flip/sprite/heartpar.emitting = false
		dominant = false
	
	# hide in grass
	visible = not $hider.has_overlapping_areas()
	$flip/sprite.material.set_shader_parameter("col",$flip/sprite.modulate)
	


func handle_ui():
	updatestats()

	if (
		global_position.distance_squared_to(get_global_mouse_position())
		<= 30 * 30
		and global.scanner
	):
		$stats.visible = true
	else:
		$stats.visible = false


func animations():
	pass


func idlestate():
	if randi_range(1, 20) == 1:
		velocity.x = randi_range(-1, 1)


func wanderstate(delta):
	velocity += $randomlook.transform.x * speed * delta

	$randomlook.rotation_degrees += randomturning * delta

	if randf() < 0.02:
		state = STATE_IDLE
		statetime = randi_range(30, 120)


func goonstate(delta):
	var cc = get_closest_chicken()

	if not is_instance_valid(cc):
		return

	$suslook.look_at(cc.global_position)

	if position.distance_to(cc.global_position) < 20:
		cc.state = STATE_MATE
		cc.statetime = statetime
		
		partnerchickenstats = cc.chickenstats.duplicate()
		partnerchickenmutations = cc.chickenmutations.duplicate()
		
	else:
		velocity += $suslook.transform.x * speed * delta * 1.5

func corre(delta):
	if not chickenmutations.has("exploding"):
		var bros = $monsterdetector.get_overlapping_bodies()
		if bros.size() > 0:
			bros = bros[0].global_position
		else:
			bros = global.playerpos
		$suslook.look_at(bros)
		
		velocity += $suslook.transform.x * speed * delta * -1.5
	else:
		goonstate(delta)


func chasestate(targetposition: Vector2, delta):
	$randomlook.look_at(targetposition)
	
	velocity += $randomlook.transform.x * speed * delta


func get_nearest_area(areas):
	var nearest = null
	var nearest_dist := INF

	for area in areas:
		var dist = global_position.distance_squared_to(area.global_position)

		if dist < nearest_dist:
			nearest_dist = dist
			nearest = area

	return nearest
