extends Node2D

@export var textstuff : PackedStringArray = ["Yo whats good bro?", "Do you want the bananas?", "shop"]
@export var displayname : String = "Stien"

func _process(delta: float) -> void:
	$Popup.visible = $Area2D.has_overlapping_bodies()
	if global.playerpos.x > position.x: $shopkeeper.scale.x = 5
	else: $shopkeeper.scale.x = -5


func _on_area_2d_body_entered(body: Node2D) -> void:
	if randi_range(0,2) == 1:
		$sound1.play()
	else:
		$sound3.play()
