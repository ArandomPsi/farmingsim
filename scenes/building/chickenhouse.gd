extends Node2D

var eggspace : int = 5 # max amount of eggs coop can hold
var eggs : Array = []
var upgrade_cost : int = 67

func _ready() -> void:
	pass

func insert_egg():
	if len(eggs) >= eggspace:
		return
	var newegg = global.player.eggs.pop_front()
	eggs.append(newegg) #remove egg from player, add to chicken house
	get_tree().current_scene.add_child(newegg)
	newegg.visible = false
