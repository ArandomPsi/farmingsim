extends CanvasModulate

var t
@export var gradient:GradientTexture1D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t = global.time
	var value = (sin(t - PI / 2)+ 1.0 ) / 2.0
	self.color = gradient.gradient.sample(value)
