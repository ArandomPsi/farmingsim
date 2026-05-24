extends Node2D
@onready var host = get_parent().get_parent() as Node2D
var velocity : Vector2
var control : float = randf_range(0.15,0.3)


func _ready() -> void:
	var randompositions = randi_range(-2,2)
	position = host.position
	position += Vector2(randompositions,randompositions) * 1000
	


func _process(delta: float) -> void:
	velocity *= 0.95
	
	$sprite.global_rotation_degrees = velocity.x * 0.1
	
	
	position += velocity * delta
	
	if not $Area2D.has_overlapping_bodies() or position.distance_to(host.position) > 1000: #either you orbit around your host or you eat
		orbiting(delta)
	else:
		feasting(delta)
	
	

func orbiting(delta):
	
	
	velocity += transform.x * 50
	
	var v = host.position - position
	var angle = v.angle()
	rotation = lerp_angle(rotation, angle, control)
	
	


func feasting(delta):
	
	velocity += transform.x * 50
	
	var bodies = $Area2D.get_overlapping_bodies()
	
	if not bodies.is_empty():
		var target = bodies[0].position
		
		var v = target - position
		var angle = v.angle()
		rotation = lerp_angle(rotation, angle, control * 1.5)
	
	


func attackboxentered(body: Node2D) -> void: #vampire behavior lol
	host.hp += 1
