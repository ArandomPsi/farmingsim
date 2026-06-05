extends Control

@export var megaparent : Node
var pname : String = ""
var player_pixel = null

func _ready() -> void:
	global.mini_map = self
	global.instance_created.connect(_add_pixel)
	global.instance_removed.connect(_remove_pixel)
#	await get_tree().create_timer(15.0).timeout
#	get_parent().get_parent().queue_free()
	
func _process(delta: float) -> void:
	megaparent.visible = global.map_open
	if player_pixel == null and pname != "":
		var possible = get_node(pname)
		if is_instance_valid(possible):
			player_pixel = possible
	elif player_pixel != null:
		player_pixel.position = global.player.position
	
func _add_pixel(instance : String, pos : Vector2):
	var new_pixel := ColorRect.new()
	new_pixel.name = instance + "Pixel" + str(pos)
	new_pixel.size = Vector2(60, 60) * 1
	var c : Color
	match instance:
		"wood":
			c = Color("149900")
		"rock":
			c = Color("0c5900")
		"player":
			new_pixel.size *= 3 / 1.5
			c = Color("#4a1d00")
			pname = new_pixel.name
		"shop":
			new_pixel.size *= 3 / 1.5
			c = Color("#cd0023")
	new_pixel.color = c
	add_child(new_pixel)
	new_pixel.position = pos

func _remove_pixel(instance : String, pos : Vector2):
	var n : String = instance + "Pixel" + str(pos)
	n = n.replace(".", "_")
	if is_instance_valid(get_node(n)):
		get_node(n).queue_free()
