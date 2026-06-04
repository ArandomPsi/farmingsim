extends mineable
@export var horitex : Texture2D
@export var verttex : Texture2D
func _ready() -> void:
	if $sprite.texture == verttex:
		$sprite/verticalshadow.visible = $sprite.texture == $sprite/verticalshadow.texture
		$sprite/horizontalshadow.visible = false
	else:
		$sprite/horizontalshadow.visible = $sprite.texture == $sprite/horizontalshadow.texture
	
	
