extends chicken

const STATE_IDLE = 0
const STATE_WANDER = 1
const STATE_EAT = 2
const STATE_HOSTILE = 3

@onready var randomlook = $randomlook as Node2D

var animframes : int = 0

var attackrange : float = 60


func _ready() -> void:
	await get_tree().process_frame
	hp *= randf_range(3,40)
	chickenstats["size"] *= randf_range(2,4)
	chickenstats["tenderness"] *= randf_range(2,4)
	chickenstats["strength"] *= randf_range(1,3)
	speed *= randf_range(1.3,2)
	
	if chickenmutations.has("bigpeck"):
		$peck/CollisionShape2D.scale *= 3
	
	

func _process(delta: float) -> void:
	animframes -= 1
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
		STATE_HOSTILE:
			if not get_closest_chicken() == null:
				chasestate(get_closest_chicken().global_position, delta)



func handle_states():
	updatetick -= 1
	statetime -= 1
	
	# food ans stuff
	if updatetick < 0:
		currentfood -= 1
		updatetick = randi_range(20, 40)
	
	#UUUUHHH
	if chickenmutations.has("explosiveness"):
		if state != STATE_HOSTILE:
			state = STATE_HOSTILE
			statetime = 600
	elif crashingout or $chickendetector.has_overlapping_bodies():
		state = STATE_HOSTILE
		statetime = 600
		
	
	if statetime < 1:
		#euphoria stuff
		#rawr
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
	
	if animframes < 1:
		if velocity.length_squared() < 25:
			$flip/sprite.play("idle")
		else:
			$flip/sprite.play("walk")
	else:
		$flip/sprite.play("fight")
	
	
	
	if velocity.x > 0:
		$flip.scale.x = 1
	elif velocity.x < 0:
		$flip.scale.x = -1


func handle_visuals():
	# mating hearts
	if state == STATE_HOSTILE:
		$flip/sprite/heartpar.emitting = true
	else:
		$flip/sprite/heartpar.emitting = false
		dominant = false
	
	# hide in coop
	visible = not $hider.has_overlapping_areas()
	

func handle_ui():
	updatestats()

	if (global.scanner):
		$stats.visible = true
		$stats/Label.position = get_viewport().get_canvas_transform() * global_position - $stats/Label.size/2 + Vector2(0,-40)
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
		cc.state = STATE_HOSTILE
		cc.statetime = statetime

		partnerchickenstats = cc.chickenstats.duplicate()

	else:
		velocity += $suslook.transform.x * speed * delta * 1.5


func chasestate(targetposition: Vector2, delta):
	$randomlook.look_at(targetposition)
	
	velocity += $randomlook.transform.x * speed * delta
	
	if targetposition.distance_to(position) < attackrange:
		pass
	



func get_nearest_area(areas):
	var nearest = null
	var nearest_dist := INF

	for area in areas:
		var dist = global_position.distance_squared_to(area.global_position)

		if dist < nearest_dist:
			nearest_dist = dist
			nearest = area

	return nearest


func _on_peck_body_entered(body: Node2D) -> void:
	if not body == self:
		body.damage(chickenstats["strength"])
		bounce(body)
		animframes = 5
		var b = preload("res://scenes/vfx/daggereffect.tscn").instantiate()
		add_child(b)
		b.look_at(body.global_position)
		if chickenmutations.has("bigpeck"):
			b.scale *= 3
			velocity *= 5
		createhiteffect(body.position)

func createhiteffect(pos):
	var b = preload("res://scenes/vfx/hiteffects.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position
	b.rotation = rotation
	b.scale.x  *= 1.5
	b.look_at(pos)
	




func _on_buck_1_finished() -> void:
	var buck = randi_range(0,2)
	match buck:
		0:
			$buck1.play()
		2:
			$buck2.play()
		3:
			$buck3.play()
