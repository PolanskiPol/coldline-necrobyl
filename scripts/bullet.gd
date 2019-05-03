extends KinematicBody2D

export var speed = 28
var damage
var direction
var playerPosition

func _ready():
	playerPosition = get_parent().get_node("player").position
	# la bala aparece en la posicion del jugador
	position = playerPosition
	
	# la variable "dir" es la direccion a la que va a ir la bala
	# "playerPosition" es la posicion inicial (donde esta el jugador)
	# "get_global_mouse_position()" es la posicion final (donde esta puesto el raton)
	# "normalized()" nos devuelve la direccion del vector (velocidad de X y velocidad de Y)
	direction = (get_global_mouse_position()-playerPosition).normalized()

func _physics_process(delta):
	# mover la bala en cada Frame
	var collision = move_and_collide(direction*speed)
	if(collision and collision.collider.collision_layer == 2):
		collision.collider.damage(damage)
	if(collision):
		get_parent().remove_child(self)