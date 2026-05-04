extends Area2D
class_name attackbox
@export var damage : int = 20
@export var knockback : float = 200
@export var hitstop : float = 0.02
@export var stun : int = 30


func _on_body_entered(body):
	body.gethit(damage,knockback,global_position,stun)
