extends CharacterBody2D

@onready var camera = $Camera2D as Camera2D
@onready var sprite = $flip/sprite as AnimatedSprite2D
@onready var flip = $flip as Node2D
@onready var tilemap = get_parent().get_child(0).get_child(0) as TileMapLayer

var speed : int = 4000
var friction : float = 0.85
var movedir : Vector2
var hp : int = 100

var shakeframes : int = 0
var ropeamount : int = 1 # actual amount - 1
var eggspace : int = 3 # max eggs to carry
var eggs : Array[Node] = [] # eggs currently carrying
	

var weapons : Array = ["sniper", "glock", "uzi"] #uzi
var magsizes : Array = [6,2,1,60] #sniper,glock,shotgun, uzi
var currentmagsize : int = 6
var currentweapon : int = 0
var currentweaponname : String
var currentweaponcooldown : int = 1
var pastweaponname : String # for optimization; past frame
var reloadingframes : int = 0

var currency : int = 0
var overlappingshopkeeper = null
var textqueue : Array = []

func _ready() -> void:
	global.player = self
	$hud/Backpack.toggled.connect(_open_backpack) # HOLA SOY DORA
	$hud/Backpack.mouse_entered.connect(_show_backpack_tab.bind(true)) # you can simplify this into single line of code but i think this is optimized idk you do what is best pls ty
	$hud/Backpack.mouse_exited.connect(_show_backpack_tab.bind(false))
	$hud/shop/ExitShop.pressed.connect(_exit_shop)

func _process(delta: float) -> void:
	updateconstantvariables()
	if textqueue.size() > 0 or $hud/shop.visible:
		talkingcontrols()
	else:
		controls()
	updatepos(delta)
	updatevisuals()
	updatehud()
	global.playerpos = position
	

func controls():
	movedir = Input.get_vector("left","right","up","down")
	
	$pivot.look_at(get_global_mouse_position())
	if get_global_mouse_position().x > position.x:
		$pivot/guns.scale.y = 5
	else:
		$pivot/guns.scale.y = -5
	
	var guntype : bool = false
	
	if currentweaponname == "uzi": #rapid guns
		guntype = true
	
	if guntype and not weapons[currentweapon] == "flashlight":
		
		#brrrrrrrrrr
		if Input.is_action_pressed("shoot") :
			if currentmagsize > 0 and reloadingframes < 1 and currentweaponcooldown < 1:
				pewpew()
				currentmagsize -= 1
				currentweaponcooldown = 2
	elif not currentweaponname == "flashlight":
		
		#pew pew
		if Input.is_action_just_pressed("shoot"):
			if currentmagsize > 0 and reloadingframes < 1:
				pewpew()
				currentmagsize -= 1
	
	
	
	
	
	if Input.is_action_just_pressed("addrope"):
		$ropearea.global_position = get_global_mouse_position()
		createrope()
	
	if Input.is_action_just_pressed("interact"):
		if not $textarea.has_overlapping_areas():
			pickupegg()
		else:
			var allareas : Array = $textarea.get_overlapping_areas()
			overlappingshopkeeper = allareas[0].get_parent()
			textqueue = overlappingshopkeeper.textstuff
			
			
			
	
	if Input.is_action_just_pressed("swapweapon"):
		currentweapon += 1
		if currentweapon >= weapons.size():
			currentweapon = 0
		
		updateweapon()
	
	if Input.is_action_just_pressed("swapweapon2"):
		currentweapon -= 1
		if currentweapon < 0:
			currentweapon = 2
		
		updateweapon()
		
	
	if Input.is_action_just_pressed("weapon1"):
		currentweapon = 0
		updateweapon()
	if Input.is_action_just_pressed("weapon2"):
		currentweapon = 1
		updateweapon()
	if Input.is_action_just_pressed("weapon3"):
		currentweapon = 2
		updateweapon()
	
	
	
	
	
	
	
	if Input.is_action_just_pressed("reload") and not currentweaponname == "flashlight":
		reloadingframes = 30
		match currentweaponname:
			"glock":
				currentmagsize = magsizes[0]
			"shotgun":
				currentmagsize = magsizes[1]
			"sniper":
				currentmagsize = magsizes[2]
			"uzi":
				currentmagsize = magsizes[3]
	
	
	
	
	$CollisionShape2D.disabled = not global.editing
	

func talkingcontrols():
	
	if not textqueue.is_empty():
		$hud/text/text.text = textqueue[0]
		if Input.is_action_just_pressed("interact"):
			textqueue.pop_front()
		if textqueue[0] == "shop":
			$hud/shop.visible = true
			textqueue.clear()
	
	if Input.is_action_just_pressed("exit"):
		$hud/shop.visible = false
		textqueue.clear()
	
	


func updatepos(delta : float):
	velocity += movedir.normalized() * speed * delta
	velocity *= friction
	move_and_slide()

func updatevisuals():
	
	
	flipstuff()
	camerastuff()
	playeranimstuff()
	effectsandstuff()
	
	

func updatehud():
	
	$hud/Panel/coinlabel.text = str(currency)
	$hud/text.visible = textqueue.size() > 0
	if not currentweaponname == "flashlight":
		$hud/bulletamount.text = str(currentmagsize) + "/" + str(magsizes[currentweapon-1])
		$hud/bulletamount.visible = true
	else:
		$hud/bulletamount.visible = false
	
	$hud/inventory/currentslotthing.position.x = currentweapon * 46.0
	

func updateconstantvariables():
	shakeframes -= 1
	shakeframes = clamp(shakeframes,0,20)
	reloadingframes -= 1
	currentweaponcooldown -= 1
	currentweaponname = weapons[currentweapon]

func pewpew():
	match currentweaponname:
		"glock":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			shakeframes += 5 #feedback
		"shotgun":
			for i in range(8):
				var b = preload("res://scenes/player/bullet.tscn").instantiate()
				get_parent().add_child(b)
				b.position = $pivot/guns.global_position
				b.rotation = $pivot.rotation
				b.rotation_degrees += randf_range(-10,10)
				b.speed *= randf_range(0.7,1.2)
				b.frames = 10
			shakeframes += 8 #feedback
		"sniper":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			shakeframes += 15 #feedback
			b.frames = 300
			b.speed *= 1.25
			b.scale.x *= 2
			b.damage = 20
		"uzi":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			b.position += b.transform.x * 30
			b.rotation_degrees += randf_range(-2,2)
			shakeframes += 2 #feedback
	
	

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
	if reloadingframes > 1:
		$pivot/guns.rotation_degrees -= 24 * ($pivot/guns.scale.y/5)
	else:
		$pivot/guns.rotation = lerp_angle($pivot/guns.rotation,0.0,0.15)
	
	
	$pivot/guns/scope.visible = currentweaponname == "sniper" and not reloadingframes > 1
	
	
	

func effectsandstuff():
	$pivot/guns/light.visible = $pivot/guns.animation == "flashlight"
	$nightlight.visible = global.isnight


func flipstuff():
	if get_global_mouse_position().x > position.x:
		flip.scale.x = 1
	else:
		flip.scale.x = -1

func camerastuff():
	
	var divisor : float = 4
	
	if currentweaponname == "sniper":
		divisor = 3
	
	camera.position = get_local_mouse_position()/divisor
	
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
			

func updateweapon():
	currentweaponname = weapons[currentweapon]
	var a : float
	match currentweaponname:
		"glock":
			currentmagsize = magsizes[0]
			a = 1.5
		"shotgun":
			currentmagsize = magsizes[1]
			a = 1.6
		"sniper":
			currentmagsize = magsizes[2]
			a = 1.2
		"uzi":
			a = 1.6
			currentmagsize = magsizes[3]
	
	if not currentweaponname == pastweaponname:
		camzoomtween(a)
	pastweaponname = currentweaponname

func camzoomtween(amount : float):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, "zoom", amount * Vector2.ONE, 0.2)
	print(camera.zoom)
	await tween.finished

func _open_backpack(pressed : bool):
	$hud/Backpack/Inv.visible = pressed
	$hud/Backpack.release_focus()
func _show_backpack_tab(hovered : bool):
	$hud/Backpack/Label.visible = hovered
func _exit_shop():
	textqueue.clear()
	$hud/shop.visible = false

func damage(amount):
	hp -= amount
	
