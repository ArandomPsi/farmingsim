extends Node2D

@export var textstuff : PackedStringArray = ["Yo whats good bro?", "Do you want the bananas?"]


func _process(delta: float) -> void:
	$Popup.visible = $Area2D.has_overlapping_bodies()
	if global.playerpos.x > position.x: $shopkeeper.scale.x = 5
	else: $shopkeeper.scale.x = -5
