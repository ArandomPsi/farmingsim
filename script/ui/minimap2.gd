extends SubViewport

@export var camera : Node2D

func _ready() -> void:
	global.minimapthingy = self
	world_2d = get_tree().root.world_2d
	

func _process(delta: float) -> void:
	camera.global_position = global.playerpos
