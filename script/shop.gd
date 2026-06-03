extends Node2D

@export var textstuff : PackedStringArray = ["Yo whats good bro?", "anyways...", "shop"]
@export var secondlist : PackedStringArray = ["did you know that you can find wood from trees", "you can fence up chickens to keep them alive", 
"you need one stone to make a dagger. It does decent damage", "only kill a chicken when you have more than 2 alive", "YES BUY A GLOCK FROM ME", "you delete everything in a chest by breaking it", 
"you can buy a scouter to make finding mutations easier", "man oh man, look at what we've built", "welcome to little saint jane's island", "im gonna goon all over you"]
@export var displayname : String = "Stien"

var currentgoal : int = 0

func _ready() -> void:
	global.instance_created.emit("shop", position)

func _process(delta: float) -> void:
	
	$Popup.visible = $Area2D.has_overlapping_bodies()
	if global.playerpos.x > position.x: $shopkeeper.scale.x = 5
	else: $shopkeeper.scale.x = -5


func _on_area_2d_body_entered(body: Node2D) -> void:
	if randi_range(0,2) == 1:
		$sound1.play()
	else:
		$sound3.play()
