extends KinematicBody2D

export var speed = 0
export var damage = 0
var direction
var playerPosition
var hit
var selfEnemyPosition

func _ready():
	playerPosition = get_parent().get_parent().get_node("player").position
	look_at(get_global_mouse_position())
	hit = false
	
	# la variable "dir" es la direccion a la que va a ir la bala
	# "position" es la posicion inicial (donde esta el enemigo)
	# "playerPosition" es la posicion final (donde esta el jugador)
	# "normalized()" nos devuelve la direccion del vector (velocidad de X y velocidad de Y)
	direction = (playerPosition-position).normalized()

func _physics_process(delta):
	# mover la bala en cada Frame
	var collision = move_and_collide(direction*speed)
	if(collision and collision.collider.collision_layer == 1):
		gameController.health -= damage
	if(collision):
		particles(collision)
		waitAndRemoveBullet(0.15)

# funcion para controlar las particulas en un impacto
func particles(coll):
	# cambiar color a rojo si colisiona con un enemigo
	if(coll.collider.collision_layer == 2):
		$hitParticles.color = Color(255, 0, 0)

	$hitParticles.emitting = true

# esperar "wait" para eliminar la bala
func waitAndRemoveBullet(wait):
	if(!hit):
		hit = true
		speed = 0
		$Sprite.visible = false
		remove_child($CollisionShape2D)
		
		$particlesTimer.start()
		yield($particlesTimer, "timeout")
		$hitParticles.emitting = false
		$particlesTimer.wait_time = wait
		
		$particlesTimer.start()
		yield($particlesTimer, "timeout")
		get_parent().remove_child(self)
		
