extends CharacterBody2D

@onready var camera = $Camera2D as Camera2D
@onready var sprite = $flip/sprite as AnimatedSprite2D
@onready var flip = $flip as Node2D
@onready var tilemap = get_parent().get_child(0).get_child(0) as TileMapLayer

var speed : int = 4000
var friction : float = 0.85
var movedir : Vector2
var hp : float = 100

var shakeframes : int = 0
var ropeamount : int = 1 # actual amount - 1
var eggspace : int = 3 # max eggs to carry
var eggs : Array[Node] = [] # eggs currently carrying


@export var playerinventory : inventory

#first 3 slots in inventory
var guns : Array = ["glock", "shotgun", "sniper","uzi"]

var weapons : Array = ["dagger", "glock", "uzi"] #uzi
var consumables : Array = ["drumstick"]
var buildings : Array = ["fence"]


var magsizes : Array = [6,2,1,60,100] #sniper,glock,shotgun, uzi, dagger
var rounds : int = 10
var currentmagsize : int = 6
var currentweapon : int = 0
var currentweaponname : String
var currentweaponcooldown : int = 1
var pastweaponname : String # for optimization; past frame
var reloadingframes : int = 0
var melee : bool = false
var consumingframes : int = 0
var current_phantom_building : Sprite2D

var stepframes : int = 0

var currency : int = 0
var overlappingshopkeeper = null
var textqueue : Array = []

func _ready() -> void:
	global.player = self
	rounds = playerinventory.inventoryhas(load("res://assets/inventoryresources/round.tres"),1,true)
	$hud/shop/ExitShop.pressed.connect(_exit_shop)


func _process(delta: float) -> void:
	updateconstantvariables()
	if hp > 0:
		if textqueue.size() > 0 or $hud/shop.visible or $hud/inventoryui.visible:
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
	
	if not consumables.has(currentweaponname) and not buildings.has(currentweaponname):
		if guntype and not currentweaponname == "flashlight":
			
			#brrrrrrrrrr
			if Input.is_action_pressed("shoot") :
				if currentmagsize > 0 and reloadingframes < 1 and currentweaponcooldown < 1:
					pewpew()
					currentmagsize -= 1
					currentweaponcooldown = 2
		elif not currentweaponname == "flashlight":
			
			#pew pew
			if Input.is_action_just_pressed("shoot"):
				if currentweaponname in ["dagger","pickaxe"]:
					pewpew()
				elif currentmagsize > 0 and reloadingframes < 1:
					pewpew()
					currentmagsize -= 1
	elif buildings.has(currentweaponname):
		handle_building(Input.is_action_just_pressed("shoot"))
	else:
		#eating
		
		if Input.is_action_pressed("shoot"):
			consumingframes += 1
			if consumingframes > 80:
				omnomnom()
				consumingframes = 0
	
	if not Input.is_action_pressed("shoot"):
		consumingframes = 0
	
	
	
	
	if Input.is_action_just_pressed("addrope"):
		$ropearea.global_position = get_global_mouse_position()
		createrope()
	
	if Input.is_action_just_pressed("interact"):
		var allareas : Array = $textarea.get_overlapping_areas()
		if not allareas.is_empty(): #for chickens and stuff
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
	
	
	
	
	
	
	
	if Input.is_action_just_pressed("reload") and currentweaponname in guns and rounds > 0:
		reloadingframes = 30
		$localaudio/reload.play()
		playerinventory.removeitem(load("res://assets/inventoryresources/round.tres"),1) #remove rounds
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
	movedir = Vector2.ZERO
	if not textqueue.is_empty():
		$hud/text/text.text = textqueue[0]
		if Input.is_action_just_pressed("interact"):
			textqueue.pop_front()
		if textqueue[0] == "shop":
			$hud/shop.visible = true
			textqueue.clear()
	
	if Input.is_action_just_pressed("exit"):
		$hud/shop.visible = false
		$hud/inventoryui.close()
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
	$hud/hpbar.value = hp
	$hud/Panel/coinlabel.text = str(currency)
	$hud/text.visible = textqueue.size() > 0
	if currentweaponname in guns:
		$hud/bulletamount.text = str(currentmagsize) + "/" + str(rounds)
		$hud/bulletamount.visible = true
	else:
		$hud/bulletamount.visible = false
	
	$hud/inventory/currentslotthing.position.x = currentweapon * 46.0
	
	#terrible optimization lol
	
	
	
	

func updatehotbar():
	pass


func updateconstantvariables():
	
	rounds = playerinventory.inventoryhas(load("res://assets/inventoryresources/round.tres"),1,true)
	shakeframes -= 1
	shakeframes = clamp(shakeframes,0,20)
	reloadingframes -= 1
	currentweaponcooldown -= 1
	weapons[0] = $hud/inventoryui.hotbarslot1.currentitem
	weapons[1] = $hud/inventoryui.hotbarslot2.currentitem
	weapons[2] = $hud/inventoryui.hotbarslot3.currentitem
	if weapons[currentweapon] != null:
		currentweaponname = weapons[currentweapon].name
	else:
		currentweaponname = ""
	

func pewpew():
	match currentweaponname:
		"glock":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			shakeframes += 5 #feedback
			createshoteffect(b.global_position)
		"shotgun":
			for i in range(8):
				var b = preload("res://scenes/player/bullet.tscn").instantiate()
				get_parent().add_child(b)
				b.position = $pivot/guns.global_position
				b.rotation = $pivot.rotation
				b.rotation_degrees += randf_range(-10,10)
				b.speed *= randf_range(0.7,1.2)
				b.frames = 10
			createshoteffect($pivot/guns.global_position)
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
			createshoteffect(b.global_position)
		"uzi":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			b.position += b.transform.x * 30
			b.position += b.transform.y * randf_range(-8,8)
			b.rotation_degrees += randf_range(-2,2)
			shakeframes += 2 #feedback
			createshoteffect($pivot/guns.global_position)
		"dagger":
			var b = preload("res://scenes/player/bullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = $pivot/guns.global_position
			b.rotation = $pivot.rotation
			b.position += b.transform.x * 30
			b.frames = 7
			b.speed = 1000
			b.visible = false
			b.damage = 2
			dagger_tween()
			var c = preload("res://scenes/vfx/daggereffect.tscn").instantiate()
			add_child(c)
			c.global_position = $pivot/guns.global_position
			c.global_rotation = $pivot.rotation
			c.global_position += c.global_transform.x * 60
		"basicegg":
			if $coopchecker.has_overlapping_areas():
				playerinventory.items.pop_at(currentweapon) #clear the spot
				$hud/inventoryui.updateslots()
				var b = load("res://scenes/egg.tscn").instantiate()
				get_parent().add_child(b)
				var areas = $coopchecker.get_overlapping_areas()
				b.position = areas[0].global_position
				b.visible = false
		"pickaxe":
			$pivot/guns.rotation_degrees += 80 * $pivot/guns.scale.y
			if $orechecker.has_overlapping_areas():
				mineore()

		

func omnomnom():
	match currentweaponname:
		"drumstick":
			hp = 100
	playerinventory.removeitem(weapons[currentweapon],1)
	

func handle_building(place : bool):
	
	var clampedangle = rad_to_deg(
	wrapf($pivot.rotation, 0.0, TAU)
	)
	match currentweaponname:
		"fence":
			if place:
				var b = load("res://scenes/building/fence.tscn").instantiate()
				b.global_position = $phantom.global_position
				b.get_child(0).texture = $phantom.texture
				b.rotation_degrees = snapped(wrapf($pivot.rotation_degrees, 0.0, 360.0), 90.0) + 90
				b.get_child(0).global_rotation_degrees = 0
				get_parent().add_child(b)
			else:
				
				var phantom = $phantom as Sprite2D
				phantom.visible = true
				phantom.rotation_degrees = clampedangle #trying to fix something
				phantom.rotation_degrees = snapped(wrapf($pivot.rotation_degrees, 0.0, 360.0), 90.0) #snapping
				print(str(phantom.rotation_degrees))
				#if the rotation is 90 or 270, then make the texture the vertical texture
				#else make it the original texture
				if phantom.rotation_degrees == 180 or phantom.rotation_degrees == 0 or phantom.rotation_degrees == 360:
					phantom.texture = load("res://assets/buildings/verticalfence.png")
				else:
					phantom.texture = load("res://assets/buildings/fence.png")
				
				phantom.rotation = 0
				
				
				phantom.scale = playerinventory.get_data(weapons[currentweapon], [6]).phantom_scale
				phantom.global_position = round(get_global_mouse_position() / 14) * 14
				var maxdist : float = 180
				var offset = phantom.global_position - global_position
				
				if offset.length() > maxdist:
					offset = offset.normalized() * maxdist
				
				phantom.global_position = global_position + offset
				phantom.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				phantom.modulate.a = 0.5
				
				



#trees count as ores :P
func mineore():
	$localaudio/break.play()
	#checks all the ores
	#stuff array holds all the minables
	var stuff = [mineable]
	shakeframes += 5
	stuff = $orechecker.get_overlapping_areas()
	for i in range(stuff.size()):
		var thingy = stuff[i].get_parent() as mineable #blah blah blah
		playerinventory.additem(thingy.helditem) #add that item
		thingy.getmined()

func createshoteffect(pos):
	var b = preload("res://scenes/vfx/shot.tscn").instantiate()
	get_parent().add_child(b)
	b.position = pos
	b.rotation = $pivot.global_rotation

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
		thing.createrope(b) #to prevent a bug
		


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
	if not weapons[currentweapon] == null:
		$pivot/guns.set_texture(weapons[currentweapon].texture) #clean code ig
	else:
		$pivot/guns.texture = null
	if reloadingframes > 1:
		$pivot/guns.rotation_degrees -= 24 * ($pivot/guns.scale.y/5)
	else:
		$pivot/guns.rotation = lerp_angle($pivot/guns.rotation,0.0,0.15)
	
	$phantom.visible = buildings.has(currentweaponname)
	
	$pivot/guns/scope.visible = currentweaponname == "sniper" and not reloadingframes > 1
	
	if consumingframes > 1:
		$pivot/guns.position = Vector2(2 * $flip.scale.x,14)
		$pivot.rotation = 0
		$pivot/guns.scale.x = $flip.scale.x * 5
	else:
		$pivot/guns.scale.x = 5
		$pivot/guns.position = Vector2(21,0)
	
	
	

func effectsandstuff():
	$pivot/guns/light.visible = currentweaponname == "flashlight"
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
	

func updateweapon():
	var a : float
	var h : bool = false
	if not weapons[currentweapon] == null:
		currentweaponname = weapons[currentweapon].name
	match currentweaponname:
		"glock":
			currentmagsize = magsizes[0]
			a = 1.45
		"shotgun":
			currentmagsize = magsizes[1]
			a = 1.47
		"sniper":
			currentmagsize = magsizes[2]
			a = 1.2
		"uzi":
			a = 1.6
			currentmagsize = magsizes[3]
		"dagger":
			a = 1.5
			h = true
			currentmagsize = magsizes[4]
		"flashlight":
			a = 1.5
		_:
			a = 1.5
	$hud/bulletamount.visible = not h

	if not currentweaponname == pastweaponname:
		camzoomtween(a)
	pastweaponname = currentweaponname

func camzoomtween(amount : float):
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, "zoom", amount * Vector2.ONE, 0.2)
	#print(camera.zoom)
	await tween.finished


func _exit_shop():
	textqueue.clear()
	$hud/shop.visible = false

func damage(amount):
	if hp >= 1: #can't die anymore
		hp -= amount
		var b = preload("res://scenes/vfx/bloodspray.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		if amount > 1:
			hitstop(0.2)
		if hp < 1:
			die()

func hitstop(amount : float):
	var b = preload("res://scenes/vfx/hitstop.tscn").instantiate()
	b.time = amount
	get_tree().current_scene.add_child(b)
	

func die():
	sprite.play("die")
	sprite.z_index += 10
	$hud.visible = false
	tweendeathzoom()
	$flip/sprite/deathbg.visible = true
	$flip/sprite/deathbg.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($flip/sprite/deathbg,"modulate",Color(1,1,1,1),0.5)
	var timer = get_tree().create_timer(2)
	await timer.timeout
	$youdied.visible = true
	var deathmessages : PackedStringArray = ["holy shit you fucking suck at this", "you stupid fucking looser", "l bozo", "your dumbass couldn't handle it", "suck my fucking cock pussy", "yo yo yo. u suck", "awwww a little bitch died... who the fuck cares?"]
	$youdied/Label2.text = deathmessages[randi_range(0,deathmessages.size()-1)]
	$youdied/Label2.visible_ratio = 0.0
	var tween2 = create_tween()
	tween2.tween_property($youdied/Label2,"visible_ratio",1.0,0.8).set_delay(0.8)
	
	


func tweendeathzoom():
	var tween = create_tween()
	tween.tween_property($Camera2D,"position",Vector2.ZERO,0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Camera2D,"zoom",Vector2(3,3),0.8).set_trans(Tween.TRANS_CUBIC)


func dagger_tween():
	currentmagsize = 0
	var g = $pivot/guns
	g.position.x = 21.0
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var og = g.position
	tween.tween_property(g, "position", Vector2(60,0), 0.05).set_ease(Tween.EASE_IN)
	tween.tween_property(g, "position", og, 0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	currentmagsize = 100


func _on_sprite_frame_changed() -> void:
	if $flip/sprite.animation == "walk":
		if $flip/sprite.frame == 0 or $flip/sprite.frame == 2:
			$localaudio/step.play()
