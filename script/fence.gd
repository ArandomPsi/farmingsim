extends mineable
func _ready() -> void:
	$sprite/verticalshadow.visible = $sprite.texture == $sprite/verticalshadow.texture
	$sprite/horizontalshadow.visible = $sprite.texture == $sprite/horizontalshadow.texture
