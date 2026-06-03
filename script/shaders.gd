extends CanvasLayer

@onready var player = get_parent() as CharacterBody2D
var prevcampos : Vector2

func _ready() -> void:
	$motionblur.visible = false
	

func _process(delta: float) -> void:
	var cam_pos = player.camera.global_position
	var cam_vel = (cam_pos - prevcampos) / delta * 1.5
	
	var blur_dir = (player.velocity + cam_vel) * 0.000004
	
	$motionblur.material.set_shader_parameter("dir", blur_dir)
	
	prevcampos = cam_pos
	
	$reddeath.modulate.a = 1 - float(get_parent().hp) / 100.0 #red lines
