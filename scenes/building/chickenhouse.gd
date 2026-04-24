extends Node2D

var eggspace : int = 5 # max amount of eggs coop can hold
var eggs : Array = []

func _process(delta: float) -> void:
	var in_range = global_position.distance_squared_to(global.playerpos) <= pow(100, 2)
	$Popup.visible = in_range
	$Popup/egglabel.text = "%d / %d" % [len(eggs), eggspace]
	if Input.is_action_just_pressed("interact") and in_range and len(global.player.eggs) > 0:
		insert_egg()
	if len(eggs) > 0:
		for egg in eggs:
			if is_instance_valid(egg):
				egg.timemult = 1.5
			else:
				eggs.erase(egg)
	

func insert_egg():
	if len(eggs) >= eggspace:
		return
	var newegg = global.player.eggs.pop_front()
	eggs.append(newegg) #remove egg from player, add to chicken house
	get_tree().current_scene.add_child(newegg)
	newegg.visible = false
