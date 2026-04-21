extends CharacterBody2D

@onready var camera = $Camera2D as Camera2D
@onready var sprite = $flip/sprite as AnimatedSprite2D
@onready var flip = $flip as Node2D
@onready var tilemap = get_parent().get_child(0).get_child(0) as TileMapLayer

var speed : int = 4000
var friction : float = 0.85
var movedir : Vector2

var shakeframes : int = 0

func _process(delta: float) -> void:
	updateconstantvariables()
	controls()
	updatepos(delta)
	updatevisuals()
	

func controls():
	movedir = Input.get_vector("left","right","up","down")
	
	$pivot.look_at(get_global_mouse_position())
	if get_global_mouse_position().x > position.x:
		$pivot/AnimatedSprite2D.scale.y = 5
	else:
		$pivot/AnimatedSprite2D.scale.y = -5
	
	if Input.is_action_just_pressed("shoot"):
		pewpew()
	
	
	

func updatepos(delta : float):
	velocity += movedir.normalized() * speed * delta
	velocity *= friction
	move_and_slide()

func updatevisuals():
	
	
	flipstuff()
	camerastuff()
	playeranimstuff()
	
	

func updateconstantvariables():
	shakeframes -= 1
	shakeframes = clamp(shakeframes,0,20)

func pewpew():
	var b = preload("res://scenes/player/bullet.tscn").instantiate()
	get_parent().add_child(b)
	b.position = $pivot/AnimatedSprite2D.global_position
	b.rotation = $pivot.rotation
	shakeframes += 5 #feedback


func selectionmode():
	var local_pos = tilemap.to_local(get_global_mouse_position())
	var cell = tilemap.local_to_map(local_pos)
	tilemap.set_cells_terrain_connect([cell], 0, 0, false)

func playeranimstuff():
	if not movedir == Vector2.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")

func flipstuff():
	if get_global_mouse_position().x > position.x:
		flip.scale.x = 1
	else:
		flip.scale.x = -1

func camerastuff():
	camera.position = get_local_mouse_position()/3
	
	camera.offset = Vector2(randf_range(-5,5),randf_range(-5,5)) * shakeframes
	
