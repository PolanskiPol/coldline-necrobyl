extends KinematicBody2D

export var speed = 28
var damage
var direction
var playerPosition
var hit
var accuracyAngle

func _ready():
	setupBullet()
	setupBulletDirection()

func setupBullet():
	accuracyAngle = get_parent().get_parent().get_node("player/weapon").accuracyAngle
	playerPosition = get_parent().get_parent().get_node("player/bulletInstancePosition").global_position
	damage = get_parent().get_parent().get_node("player/weapon").damage
	position = playerPosition
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	hit = false
	
func setupBulletDirection():
	randomize()
	var random1 = rand_range(-accuracyAngle, accuracyAngle)
	var random2 = rand_range(-accuracyAngle, accuracyAngle)
	
	# la variable "dir" es la direccion a la que va a ir la bala
	# "playerPosition" es la posicion inicial (donde esta el jugador)
	# "get_global_mouse_position()" es la posicion final (donde esta puesto el raton)
	# "normalized()" nos devuelve la direccion del vector (velocidad de X y velocidad de Y)
	direction = ((get_global_mouse_position()-playerPosition)).normalized()
	direction.x += random1
	direction.y += random2

func _physics_process(delta):
	# mover la bala en cada Frame
	var collision = move_and_collide(direction*speed)
	if(collision and collision.collider.collision_layer == 2):
		collision.collider.damage(damage)
	if(collision):
		particles(collision)
		waitAndRemoveBullet(0.15)

# funcion para controlar las particulas en un impacto
func particles(coll):
	# cambiar color a rojo si colisiona con un enemigo
	if(coll.collider.collision_layer == 2):
		$hitParticles.color = Color(255, 0, 0)
		$hitParticles.amount = 15
		$hitParticles.rotation_degrees += 180

	$hitParticles.emitting = true
	$stopParticles.start(0)

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
		

func _on_stopParticles_timeout():
	$hitParticles.emitting = false


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
