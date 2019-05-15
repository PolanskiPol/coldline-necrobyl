extends Node2D

# variables de "configuracion" del arma
export var weaponName = "Machinegun"
export var damage = 75
export var mag = 20 #cuando mag es "-1", las balas son infinitas
export var timeBetweenShots = 0.1
export var timeToReload = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = timeBetweenShots
	setupGameController()
	#print(weaponName.get_Path())

func _physics_process(delta):
	# "action_just_pressed" para semiautomatico. quitar el "just_" para automatico
	if(Input.is_action_pressed("event_leftclick") and $Timer.time_left <= 0 and gameController.canShoot):
		shoot()

# funcion para disparar
func shoot():
	# la pistola tiene municion infinita, asi que no tiene comando para restar balas
	# indicamos que escena se va a instanciar (la bala en este caso)
	var bullet = load("res://scenes/player/bulletShootgun.tscn")
	# instanciamos la escena (la bala)
	var bulletInstance = bullet.instance()
	# metemos la escena instanciada (la bala) en la escena actual (el nivel en el que estamos)
	get_parent().get_parent().add_child(bulletInstance)
#	get_parent().get_parent().get_node("bullet1").rotation += 2
#	get_parent().get_parent().get_node("bullet2").rotation += 1
#	get_parent().get_parent().get_node("bullet").rotation += -2
#	get_parent().get_parent().get_node("bullet").position += Vector2(100, 10)
	bulletInstance.get_node("bullet1").damage = damage
	$shoot.play()
	gameController.bullets -= 1

	# si queremos gastar balas:
	# gameController.bullets -= 1

	# ponemos un pequeño "delay" entre disparos
	waitBetweenShots(timeBetweenShots)

# prepara "gameController.gd" para que la UI saque bien la información
func setupGameController():
	gameController.weaponName = weaponName
	gameController.bullets = mag

# funcion para que haya un tiempo despera entre acciones
func waitBetweenShots(wait):
	gameController.canShoot = false
	$Timer.start()
	yield($Timer, "timeout")
	$Timer.wait_time = wait
	if(!gameController.zoomedOut):
		gameController.canShoot = true