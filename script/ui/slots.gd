extends Panel
@onready var sprite = $sprite as AnimatedSprite2D
@export var slot : int = 0
func _ready() -> void:
	sprite.sprite_frames = sprite.sprite_frames.duplicate()

func _process(delta: float) -> void:
	if global.player.weapons[slot] != "":
		sprite.play(global.player.weapons[slot])
	else:
		sprite.play("new_animation")
