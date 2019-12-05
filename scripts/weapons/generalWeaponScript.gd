extends Node2D

# variables de "configuracion" del arma
export var weaponName = ""
export var damage = 0
export var bulletsPerShot = 1
export var mag = -1 #cuando mag es "-1", las balas son infinitas
export var timeBetweenShots = 0.0
export var accuracyAngle = 0.0
export var usesAmmo = false
export var automatic = false
export(AudioStreamSample) var sound
#export(PackedScene) var bulletToInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = timeBetweenShots
	setupGameController()
	
func _physics_process(delta):
	# "action_just_pressed" para semiautomatico. quitar el "just_" para automatico
	if(Input.is_action_pressed("event_leftclick") and $Timer.time_left <= 0 and gameController.canShoot and automatic):
		shoot()
	elif(Input.is_action_just_pressed("event_leftclick") and $Timer.time_left <= 0 and gameController.canShoot and !automatic):
		shoot()
#
#func _input(event):
#	if(event.is_action_pressed("event_leftclick") and $Timer.time_left <= 0 and gameController.canShoot and !automatic):
#		shoot()

#func addBulletToScene(bulletInstance):
#	if(bulletInstance.name == "bullet"):
#		print(get_parent().name)
#		add_child(bulletInstance)
#	elif(bulletInstance.name == "bulletInstance"):
#		print(get_parent().get_parent().name)
#		get_parent().get_parent().add_child(bulletInstance)

# funcion para disparar
func shoot():
	# la pistola tiene municion infinita, asi que no tiene comando para restar balas
	# indicamos que escena se va a instanciar (la bala en este caso)
	var bullet = load("res://scenes/weapons/bulletInstance.tscn")
	# instanciamos la escena (la bala)
	var bulletInstance = bullet.instance()
	# metemos la escena instanciada (la bala) en la escena actual (el nivel en el que estamos)
	get_parent().get_parent().add_child(bulletInstance) # addBulletToScene(bulletInstance)
	get_parent().get_node("shootWeapon").stream = sound
	get_parent().get_node("shootWeapon").play()
	if(usesAmmo):
		gameController.bullets -= 1
	
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
	if(!gameController.zoomedOut and gameController.health > 0):
		gameController.canShoot = true