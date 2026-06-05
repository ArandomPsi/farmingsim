extends Control
var toggled : bool = false

func _process(delta: float) -> void:
	
	if toggled:
		$ScrollContainer.position.x = lerpf($ScrollContainer.position.x,56.0,0.18)
		
	else:
		$ScrollContainer.position.x = lerpf($ScrollContainer.position.x,437.0,0.18)


func _on_button_pressed() -> void:
	toggled = not toggled
