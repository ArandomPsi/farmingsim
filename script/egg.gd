extends Node2D
var chickenstats : Dictionary = {
	"size" : randf_range(1,20),
	"tenderness" : randf_range(1,20),
	"explosiveness": 75
}
var hatchtime : float = chickenstats.size * 0.85
var eggtimer : float = hatchtime
var timemult : float = 0.8 # for chicken coop speeding up
#var picked_up : bool = false # debug bc not working without it
@onready var popup: Node2D = $Popup



func _ready() -> void:
	if chickenstats.is_empty(): print("error - " + str(position)); queue_free() #saftey
	chickenstats["size"] *= randf_range(0.8,1.5)
	chickenstats["tenderness"] *= randf_range(0.8,1.5)

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
	var b = preload("res://scenes/chicken.tscn").instantiate()
	b.global_position = global_position
	b.chickenstats = chickenstats
	get_tree().current_scene.add_child(b)
	if chickenstats["explosiveness"] >= 50:
		var c = preload("res://scenes/explodingmutation.tscn").instantiate()
		b.add_child(c)
	queue_free()

func egg_popup(status : bool): # open = true, close = false, not in use rn
	#if picked_up: return
	
	pass
	
	#global.egg_visible = status
	#var e = self if status else null
	#global.the_egg = e
	#popup.visible = status
	
