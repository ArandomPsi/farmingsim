extends CharacterBody2D
class_name chicken


const EGG_SCENE = preload("res://scenes/chicken/egg.tscn")
const DEAD_SCENE = preload("res://scenes/chicken/dedchicken.tscn")
const BLOOD_SCENE = preload("res://scenes/vfx/bloodspray.tscn")




var size : float = 1.0
var speed : float = 1500.0

@export var hp : int = 1
@export var tethered : bool = false
@export var debug : bool = false


@export var reactionstate : int = 2

var state : int = 0
var statetime : int = 0
var randomturning : float = 0.0

var currentfood : int = 100
var currentwater : int = 100
var lust : int = 50

var dominant : bool = false
var updatetick : int = 0

var ropecrash = null
var nearestcoop = null

var crashingout : bool = false



var chickenstats : Dictionary = {
	"size": randf_range(1, 20),
	"tenderness": randf_range(1, 20),
	"strength" : randf_range(1,5),
	"color" : Color(1,1,1)
}



@export var chickenmutations : Array = []

#chicken mutations:
#Exploding - Osama's chickens
#Big Peck - Toucan ahhh
#alpaca - hawctua spit on that thing
#dagger feathers - put it in me daddy
#tentacles - that one mhanwa :) 



var partnerchickenstats : Dictionary = {}
var partnerchickenmutations : Array = []



func _ready() -> void:
	randomize_stats()
	addmutations()
	
	add_to_group("chicken")
	
	scale *= max(chickenstats["size"] / 100.0, 1.0)
	
	partnerchickenstats.clear()


func randomize_stats():
	chickenstats = chickenstats.duplicate()

	chickenstats["size"] *= randf_range(0.8, 1.2)
	chickenstats["tenderness"] *= randf_range(0.8, 1.2)
	chickenstats["strength"] *= randf_range(0.8,1.2)
	
	chickenstats["color"].r *= randf_range(0.5,1.5)
	chickenstats["color"].g *= randf_range(0.8,1.1)
	chickenstats["color"].b *= randf_range(0.8,1.1)
	
	hp *= chickenstats["strength"]
	
	$flip/sprite.modulate = chickenstats["color"]
	


func addmutations():
	for i in range(chickenmutations.size()):
		match chickenmutations[i]:
			"exploding":
				var b = load("res://scenes/chicken/explodingmutation.tscn").instantiate()
				add_child(b)
				hp *= 9
			"alpaca":
				var b = load("res://scenes/chicken/alpaca.tscn").instantiate()
				add_child(b)
			"covid":
				var b = load("res://scenes/chicken/poisonmutation.tscn").instantiate()
				add_child(b)
			"daggers":
				var b = load("res://scenes/chicken/daggerfeathermutation.tscn").instantiate()
				add_child(b)
			"tentacle":
				var b = load("res://scenes/chicken/tentaclemutation.tscn").instantiate()
				add_child(b)
				speed *= 2
				hp *= 3
			"golden":
				$flip/sprite.modulate = Color("f9ff4a")
				var b = load("res://scenes/chicken/goldenmutation.tscn").instantiate()
				add_child(b)
			_:
				var b = load("res://scenes/chicken/explosion.tscn").instantiate()
				add_child(b)
	

#UUUUUUH

func layegg():
	if partnerchickenstats.is_empty():
		return
	
	if not dominant:
		return

	var egg = EGG_SCENE.instantiate()

	egg.chickenstats = average_stats(
		chickenstats,
		partnerchickenstats
	)
	egg.mutations = combine_arrays(chickenmutations,partnerchickenmutations)
	
	
	egg.mutations = chickenmutations.duplicate() #only the dominant chicken's genes survive
	
	get_parent().add_child(egg)
	
	egg.position = position + Vector2(
		randf_range(-15, 15),
		randf_range(-15, 15)
	)

	partnerchickenstats.clear()


func average_stats(a: Dictionary, b: Dictionary) -> Dictionary:
	var result := {}

	for key in a.keys():
		if b.has(key):
			result[key] = (a[key] + b[key]) * 0.5

	return result

func combine_arrays(a: Array, b: Array) -> Array:
	a.append_array(b)
	return a

#omnomom

func gobblegobble():
	$flip/sprite.play("peck")

	currentfood = min(currentfood + 1, 100)


#damage

func damage(damage):
	hp -= damage
	crashingout = true
	state = reactionstate
	print(state)
	statetime = 300
	if hp <= 0:
		die()
	else:
		spawn_blood()


func spawn_blood():
	var blood = BLOOD_SCENE.instantiate()

	blood.position = global_position

	get_parent().add_child(blood)


func die():
	var body = DEAD_SCENE.instantiate()

	body.chickenstats = chickenstats.duplicate()

	if is_instance_valid(ropecrash):
		ropecrash.queue_free()

	get_parent().add_child(body)

	body.position = position
	body.scale.x = $flip.scale.x

	# optional value scaling
	body.chickenvalue *= max(chickenstats["size"] - 2, 1)
	body.modulate = $flip/sprite.modulate
	if chickenmutations.has("golden"):
		body.chickenvalue *= 67

	queue_free()


#targeting

func get_closest_chicken() -> Node2D:
	var bodies = $chickendetector.get_overlapping_bodies()

	var closest : Node2D = null
	var closest_dist := INF

	for body in bodies:
		if body == self:
			continue
		var dist = global_position.distance_squared_to(
			body.global_position
		)

		if dist < closest_dist:
			closest_dist = dist
			closest = body

	return closest


#basic physics

func bounce(body: Node2D) -> void:
	$suslook.look_at(body.global_position)
	velocity = $suslook.transform.x * -400 * speed/1500 #for bouncing and stuff



func createrope(rope):
	ropecrash = rope


#ui

func updatestats():
	$stats/Label.text = (
		"chicken stats:\n"
		+ "size - "
		+ str(round(chickenstats["size"]))
		+ "\n"
		+ "tenderness - "
		+ str(round(chickenstats["tenderness"]))
		+ "\n"
		+ "mutations - "
		+ str(chickenmutations)
	)
