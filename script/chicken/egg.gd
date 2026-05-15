extends Node2D
var chickenstats : Dictionary = {
	"size" : randf_range(1,20),
	"tenderness" : randf_range(1,20),
	"strength" : randf_range(1,5),
	"color" : Color(1,1,1,1)
}

@export var mutations = []

var hatchtime : float = 30
var eggtimer : float = hatchtime
var timemult : float = 0.8 # for chicken coop speeding up
#var picked_up : bool = false # debug bc not working without it
@onready var popup: Node2D = $Popup



func _ready() -> void:
	if chickenstats.is_empty(): print("error - " + str(position)); queue_free() #saftey
	chickenstats["size"] *= randf_range(0.8,1.5)
	chickenstats["tenderness"] *= randf_range(0.8,1.5)
	chickenstats["strength"] *= randf_range(0.8,1.5)
	
	if randi_range(1,5) == 1: #random chance to add a random mutation
		mutations.push_back(global.allmutations[randi_range(0,global.allmutations.size()-1)])
	if randi_range(1,10) == 1 and not mutations.is_empty():
		mutations.pop_at(randi_range(0,mutations.size()-1)) #remove a random part
	
	chickenstats["color"].r *= randf_range(0.8,1.1)
	chickenstats["color"].g *= randf_range(0.8,1.1)
	chickenstats["color"].b *= randf_range(0.8,1.1)
	

func _process(delta: float) -> void:
	var in_range = global_position.distance_squared_to(global.playerpos) <= pow(30, 2)

	if in_range:
		if global.the_egg == null or not is_instance_valid(global.the_egg):
			egg_popup(true)
	elif global.the_egg == self:
		egg_popup(false)

	eggtimer -= delta * timemult
	if eggtimer <= 0.0:
		hatch()

func hatch():
	#random stuff
	var rabidchance : int = 20 #change later
	var currentchicken = "res://scenes/chicken/chicken.tscn"
	if randi_range(0,100) <= rabidchance:
		currentchicken = "res://scenes/chicken/hostilechicken.tscn"
	
	#gg ez
	print(str(mutations))
	var b = load(currentchicken).instantiate() #so for some reason it was loading circularly. Egg preload then chicken and stuff. Since chicken is a complex scene, you need load. This problem occured because chickenpassive was based on chicken class yada yada yada.
	b.chickenstats = chickenstats
	b.chickenmutations = mutations.duplicate()
	get_parent().add_child(b)
	b.position = position
	queue_free()

func egg_popup(status : bool): # open = true, close = false, not in use rn
	#if picked_up: return
	
	pass
	
	#global.egg_visible = status
	#var e = self if status else null
	#global.the_egg = e
	#popup.visible = status
	
