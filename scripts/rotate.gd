extends Label

# decoracion para las texturas de personaje en dialogos

export var rotationSpeed = 0.002
export var maxRotation = 0.12
var rotationDirection
var rotater

# Called when the node enters the scene tree for the first time.
func _ready():
	rotater = 0.01
	rotationDirection = 1

func _physics_process(delta):
	rotate()

# las luces giran de un lado a otro
func rotate():
	if(get_rotation() > maxRotation or get_rotation() < -maxRotation):
		rotationDirection *= -1
	
	rotater += rotationSpeed*rotationDirection
	set_rotation(rotater)