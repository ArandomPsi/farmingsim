extends Node2D

@onready var tentacle1 = $Node/tentacle1
@export var tentaclereach : int = 200

func _ready() -> void:
	$Node/tentacle1.global_position = position

func _process(delta: float) -> void:
	
	
	$segment.ropestuff()
	$segment2.ropestuff()
	$segment3.ropestuff()
	$segment4.ropestuff()
