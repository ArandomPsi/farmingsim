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
	
	for x in range(0,512,density):
		for y in range(0,512,density):
			var n = noisetexture.get_noise_2d(x, y)
			if n > 0.4:
				var pos = Vector2(float(x) / 512.0 * mapsize.x, float(y) / 512.0 * mapsize.y)
				#createtree(Vector2(x * mapsize.x / 512,y * mapsize.y / 512))
				createtree(pos)
			
	
	

func createtree(pos : Vector2):
	var b = preload("res://scenes/building/tree.tscn").instantiate()
	add_child(b)
	b.position = pos
	b.position += Vector2(randf_range(-randomoffset,randomoffset),randf_range(-randomoffset,randomoffset))
	
