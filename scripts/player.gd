extends KinematicBody2D

export var speed = 4.0
export var animationSpeed = 200
var lastPosition
var dead

func _ready():
	dead = false
	lastPosition = position
	addPlayerWeapon("res://scenes/player/weapons/shootgun.tscn")
	

func _physics_process(delta):
	if(!dead):
		# detectamos los Input en cada frame, asi el jugador responde mas rapido
		# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
		movePlayer()
		# get_global_mouse_position() devuelve la posicion del raton en la pantalla
		look_at(get_global_mouse_position())
		playerDie()
		cameraZoom()

func _input(event):
	restartLevel(event)
	goToNextLevel(event)

# funcion para hacer los cambios de armas del jugador
func addPlayerWeapon(weaponPath):
	var instancedWeapon = load(weaponPath).instance()
	add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)

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

# reempezar nivel
func restartLevel(event):
	if(gameController.health < 0 and event.is_action_pressed("event_r")):
		gameController.health = 100
		gameController.canShoot = true
		get_tree().reload_current_scene()
		
# pasar al siguiente nivel
func goToNextLevel(event):
	if(gameController.health >= 0 and event.is_action_pressed("event_r") and gameController.enemies <= 0):
		gameController.health = 100
		gameController.canShoot = true
		gameController.sceneToGoNumber += 1
		get_tree().change_scene("res://scenes/levels/intermission" + str(gameController.sceneToGoNumber) + ".tscn")