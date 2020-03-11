extends KinematicBody2D

signal moving

const MOVE_MODE_KM = 0
const MOVE_MODE_GAMEPAD = 1

export var speed = 4.0
export var animationSpeed = 200

var lastPosition
var dead
var lastMousePosition
var cameraRotation
var inputMode
var lookAtGamepad

func _ready():
	setup()
	
func _physics_process(delta):
	if(!dead):
		# detectamos los Input en cada frame, asi el jugador responde mas rapido
		# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
		movePlayer()
		# get_global_mouse_position() devuelve la posicion del raton en la pantalla
		setPlayerRotation()
		playerDie()
		cameraZoom()
		removeWeaponWhenMagEmpty()
		
func _input(event):
	restartLevel(event)
	goToNextLevel(event)
	setInputMode()
	devKey(event, true)
	
func devKey(event, active):
	if(event.is_action_pressed("devkey") and active):
		gameController.health = 100

func setInputMode():
	if(Input.is_action_just_pressed("event_wasd")):
		inputMode = MOVE_MODE_KM
	elif(Input.is_action_pressed("event_camera_down")):
		inputMode = MOVE_MODE_GAMEPAD

func setPlayerRotation():
	if(lastMousePosition != get_global_mouse_position()):
		look_at(get_global_mouse_position())
	lastMousePosition = get_global_mouse_position()
#func cameraRotation(maxRotation):
#	if(Input.is_action_pressed("moveKeys")):
#		print($Camera2D.global_rotation)
##		$Camera2D.set_rot

# funcion para hacer los cambios de armas del jugador
func addPlayerWeapon(weaponPath):
	removePreviousWeapon()
	var instancedWeapon = load(weaponPath).instance()
	$weaponSlot.add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)
	gameController.canShoot = true

func removePreviousWeapon():
	for i in $weaponSlot.get_children():
		if(i.name == "shootWeapon" or i.name == "bulletInstancePosition"):
			pass
		else:
			$weaponSlot.remove_child(i)
		
func removeWeaponWhenMagEmpty():
	if(gameController.bullets == 0):
		removePreviousWeapon()
		addPlayerWeapon("res://scenes/weapons/fists.tscn")

# mueve al jugador con WASD
func movePlayer():
	var motion = Vector2(0, 0)
	
	if(Input.is_action_pressed("event_s")):
		motion.y = Input.get_action_strength("event_s")
	elif(Input.is_action_pressed("event_w")):
		motion.y = -Input.get_action_strength("event_w")
	if(Input.is_action_pressed("event_a")):
		motion.x = -Input.get_action_strength("event_a")
	elif(Input.is_action_pressed("event_d")):
		motion.x = Input.get_action_strength("event_d")
	
	motion = motion.normalized() # con esto el jugador se mueve a la velocidad correcta en diagonales
	motion *= speed * 50
	move_and_slide(motion)

# acercar la camara. al hacer zoom, no puedes disparar
func cameraZoom():
	if(Input.is_action_pressed("event_shift")):
		var fixedMousePosition = get_viewport().size/2 - get_viewport().get_mouse_position()
		$Camera2D.offset.x = -fixedMousePosition.x/2.75
		$Camera2D.offset.y = -fixedMousePosition.y/2.75*16/9
	elif(Input.is_action_just_released("event_shift")):
		$Camera2D.offset = Vector2(0, 0)

# cuando la vida del jugador es menor que 0, cambiamos la escena a "gameOver.tscn"
func playerDie():
	if(gameController.health <= 0):
		gameController.canShoot = false
		dead = true

func setup():
	lookAtGamepad = Vector2()
	lastPosition = position
	addPlayerWeapon("res://scenes/weapons/fists.tscn")
	gameController.health = 100
	gameController.canShoot = true
	get_parent().get_node("tint").visible = false
	dead = false
	cameraRotation = 0
	inputMode = MOVE_MODE_KM
	
# reempezar nivel
func restartLevel(event):
	if(dead and event.is_action_pressed("event_r")):
		transition.reloadScene()
		
# pasar al siguiente nivel
func goToNextLevel(event):
	if(!dead and event.is_action_pressed("event_r") and gameController.enemies <= 0 and get_owner().name != "intermission"):
		setup()
		gameController.sceneToGoNumber += 1
		save.saveGame()
		gameController.secondLevelMusicWhenRestarted = 0
		print("res://scenes/levels/final/intermission" + str(gameController.sceneToGoNumber) + ".tscn")
		transition.changeScene("res://scenes/levels/final/intermission" + str(gameController.sceneToGoNumber) + ".tscn")
	elif(event.is_action_pressed("event_r") and get_owner().name == "intermission"):
		setup()
		save.saveGame()
		gameController.secondLevelMusicWhenRestarted = 0
		print("res://scenes/levels/final/level" + str(gameController.sceneToGoNumber) + ".tscn")
		transition.changeScene("res://scenes/levels/final/level" + str(gameController.sceneToGoNumber) + ".tscn")
