extends Node2D

@export var mapsize : Vector2 = Vector2(512,512)
@export var density : int = 8
@export var randomoffset : float = 100

func _ready() -> void:
	print("yoo")
	var noisetexture = NoiseTexture2D.new()
	var noise  = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.01
	noisetexture = noise
	
	global.new_day.connect(_create_more_trees.bind(noisetexture))
	
	for x in range(0,512,density):
		for y in range(0,512,density):
			var n = noisetexture.get_noise_2d(x, y)
			if n > 0.4:
				var pos = Vector2(float(x) / 512.0 * mapsize.x, float(y) / 512.0 * mapsize.y)
				#createtree(Vector2(x * mapsize.x / 512,y * mapsize.y / 512))
				createtree(pos)
			
	
func _create_more_trees(noisetexture):
	noisetexture.seed = randi()
	noisetexture.frequency = 0.05
	for x in range(0, 512, density * 5):
		for y in range(0, 512, density * 5):
			var n = noisetexture.get_noise_2d(x, y)
			if n > 0.4:
				var pos = Vector2(float(x) / 512.0 * mapsize.x, float(y) / 512.0 * mapsize.y)
				createtree(pos)

func createtree(pos : Vector2):
	var b = preload("res://scenes/building/tree.tscn").instantiate()
	add_child(b)
	b.position = pos
	b.position += Vector2(randf_range(-randomoffset,randomoffset),randf_range(-randomoffset * 1.5,randomoffset * 1.5))
	global.instance_created.emit("wood", b.position)
	b.position.x = clamp(b.position.x,0,mapsize.x)
	b.position.y = clamp(b.position.y, 0,mapsize.y)
