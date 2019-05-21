extends KinematicBody2D

export var speed = 4.0
export var animationSpeed = 200
var lastPosition
var dead

func _ready():
	dead = false
	lastPosition = position
	addPlayerWeapon("res://scenes/player/weapons/pistol.tscn")
	

func _physics_process(delta):
	if(!dead):
		# detectamos los Input en cada frame, asi el jugador responde mas rapido
		# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
		movePlayer()
		# get_global_mouse_position() devuelve la posicion del raton en la pantalla
		look_at(get_global_mouse_position())
		playerDie()
		cameraZoom()
		removeWeaponWhenMagEmpty()
		lastChance()

func _input(event):
	restartLevel(event)
	goToNextLevel(event)

# funcion para hacer los cambios de armas del jugador
func addPlayerWeapon(weaponPath):
	removePreviousWeapon()
	var instancedWeapon = load(weaponPath).instance()
	add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)
	gameController.canShoot = true
	
func addPistol():
	var instancedWeapon = load("res://scenes/player/weapons/pistol.tscn").instance()
	add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)
	gameController.canShoot = true
	
func removePreviousWeapon():
	if(has_node("weapon")):
		remove_child($weapon)

func removeWeaponWhenMagEmpty():
	if(gameController.bullets == 0):
		remove_child($weapon)
		addPlayerWeapon("res://scenes/player/weapons/pistol.tscn")
		gameController.canShoot = true

# mueve al jugador con WASD
func movePlayer():
	var motion = Vector2(0, 0)
	
	if(Input.is_action_pressed("event_s")):
		motion.y = 1
	elif(Input.is_action_pressed("event_w")):
		motion.y = -1
	if(Input.is_action_pressed("event_a")):
		motion.x = -1
	elif(Input.is_action_pressed("event_d")):
		motion.x = 1
	
	motion = motion.normalized() # con esto el jugador se mueve a la velocidad correcta en diagonales
	motion *= speed
	move_and_collide(motion)

# acercar la camara. al hacer zoom, no puedes disparar
func cameraZoom():
	if(Input.is_action_just_pressed("event_shift")):
		$Camera2D.zoom.x = 0.6
		$Camera2D.zoom.y = 0.6
		gameController.zoomedOut = true
		gameController.canShoot = false
	elif(Input.is_action_just_released("event_shift")):
		$Camera2D.zoom.x = 0.5
		$Camera2D.zoom.y = 0.5
		gameController.zoomedOut = false
		gameController.canShoot = true

# cuando la vida del jugador es menor que 0, cambiamos la escena a "gameOver.tscn"
func playerDie():
	if(gameController.health < 0):
		gameController.canShoot = false
		dead = true
		
func lastChance():
	if(gameController.health == 0):
		gameController.health = 1
		
# reempezar nivel
func restartLevel(event):
	if(gameController.health < 0 and event.is_action_pressed("event_r")):
		gameController.health = 100
		gameController.canShoot = true
		get_parent().get_node("tint").visible = false
		get_tree().reload_current_scene()
		
#La siguiente función vale para poner un difuminado en negro.
func nextLevelTransition():
	var transition = load("res://scenes/effects/transition.tscn").instance()
	transition.intro = false
	get_parent().get_node("UI").add_child(transition)

# pasar al siguiente nivel
func goToNextLevel(event):
	if(gameController.health >= 0 and event.is_action_pressed("event_r") and gameController.enemies <= 0):
		gameController.health = 100
		gameController.canShoot = true
		gameController.sceneToGoNumber += 1
		save.saveGame()
		gameController.secondLevelMusicWhenRestarted = 0
		nextLevelTransition()
# El Timer es para que haga bien el difuminado y que despues cambie de nivel
		$Timer.start()
		yield($Timer, "timeout")
		get_tree().change_scene("res://scenes/levels/intermission" + str(gameController.sceneToGoNumber) + ".tscn")