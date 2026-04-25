extends CharacterBody2D

@onready var camera = $Camera2D as Camera2D
@onready var sprite = $flip/sprite as AnimatedSprite2D
@onready var flip = $flip as Node2D
@onready var tilemap = get_parent().get_child(0).get_child(0) as TileMapLayer

var speed : int = 4000
var friction : float = 0.85
var movedir : Vector2

var shakeframes : int = 0
var ropeamount : int = 1 # actual amount - 1
var eggspace : int = 3 # max eggs to carry
var eggs : Array[Node] = [] # eggs currently carrying
var weapons : Array = ["flashlight", "glock"]
var currentweapon : int = 0

var currency : int = 0

func _ready() -> void:
	global.player = self

func _process(delta: float) -> void:
	updateconstantvariables()
	controls()
	updatepos(delta)
	updatevisuals()
	global.playerpos = position
	

func controls():
	movedir = Input.get_vector("left","right","up","down")
	
	$pivot.look_at(get_global_mouse_position())
	if get_global_mouse_position().x > position.x:
		$pivot/guns.scale.y = 5
	else:
		$pivot/guns.scale.y = -5
	
	if Input.is_action_just_pressed("shoot") and not weapons[currentweapon] == "flashlight":
		pewpew()
	
	if Input.is_action_just_pressed("addrope"):
		$ropearea.global_position = get_global_mouse_position()
		createrope()
	
	if Input.is_action_just_pressed("interact"):
		pickupegg()
	
	if Input.is_action_just_pressed("swapweapon"):
		currentweapon += 1
		if currentweapon >= weapons.size():
			currentweapon = 0
	
	$CollisionShape2D.disabled = not global.editing
	

func updatepos(delta : float):
	velocity += movedir.normalized() * speed * delta
	velocity *= friction
	move_and_slide()

func updatevisuals():
	
	
	flipstuff()
	camerastuff()
	playeranimstuff()
	effectsandstuff()
	
	

func updateconstantvariables():
	shakeframes -= 1
	shakeframes = clamp(shakeframes,0,20)

func pewpew():
	var b = preload("res://scenes/player/bullet.tscn").instantiate()
	get_parent().add_child(b)
	b.position = $pivot/guns.global_position
	b.rotation = $pivot.rotation
	shakeframes += 5 #feedback

func createrope():
	if $ropearea.has_overlapping_bodies():
		var thingy : Array = $ropearea.get_overlapping_bodies()
		var thing = thingy[0]
		
		for i in range($ropes.get_child_count()):
			if $ropes.get_child(i).tetheredbody == thing: #if rope is connected to the body
				$ropes.get_child(i).tetheredbody.tethered = false
				$ropes.get_child(i).queue_free()
				return
		
		if $ropes.get_child_count() > ropeamount:
			return
		var b = preload("res://scenes/player/rope.tscn").instantiate()
		$ropes.add_child(b)
		 #its an array
		b.tetheredbody = thingy[0]
		thingy[0].tethered = true
		thing.rememberrope(b) #to prevent a bug 
		


func selectionmode():
	var local_pos = tilemap.to_local(get_global_mouse_position())
	var cell = tilemap.local_to_map(local_pos)
	tilemap.set_cells_terrain_connect([cell], 0, 0, false)

func playeranimstuff():
	if not movedir == Vector2.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	#glocks and stuff
	$pivot/guns.play(weapons[currentweapon]) #clean code ig
	
	

func effectsandstuff():
	$pivot/guns/light.visible = $pivot/guns.animation == "flashlight"


func flipstuff():
	if get_global_mouse_position().x > position.x:
		flip.scale.x = 1
	else:
		flip.scale.x = -1

func camerastuff():
	camera.position = get_local_mouse_position()/3
	
	camera.offset = Vector2(randf_range(-5,5),randf_range(-5,5)) * shakeframes
	
func pickupegg():
	if len(eggs) >= eggspace:
		return
	
	if global.the_egg != null and is_instance_valid(global.the_egg):
		if global_position.distance_squared_to(global.the_egg.global_position) <= pow(25, 2):
			eggs.append(global.the_egg)
			get_tree().current_scene.remove_child(global.the_egg)
			global.the_egg = null
			global.egg_visible = false
			
