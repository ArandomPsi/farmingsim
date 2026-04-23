extends AnimatedSprite2D

func _ready() -> void:
	sprite_frames = get_parent().sprite_frames

func _process(delta: float) -> void:
	animation = get_parent().animation
	frame = get_parent().frame
