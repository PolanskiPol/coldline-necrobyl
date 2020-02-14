extends KinematicBody2D

signal moving

export var speed = 4.0
export var animationSpeed = 200

var lastPosition
var dead
var lastMousePosition

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
		lastChance()

func _input(event):
	restartLevel(event)
	goToNextLevel(event)

func setPlayerRotation():
	if(lastMousePosition != get_global_mouse_position()):
		look_at(get_global_mouse_position())
	lastMousePosition = get_global_mouse_position()

# funcion para hacer los cambios de armas del jugador
func addPlayerWeapon(weaponPath):
	removePreviousWeapon()
	var instancedWeapon = load(weaponPath).instance()
	$weaponSlot.add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)
	gameController.canShoot = true
	
func addPistol():
	var instancedWeapon = load("res://scenes/weapons/pistol.tscn").instance()
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
		addPlayerWeapon("res://scenes/weapons/pistol.tscn")

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
		
func lastChance():
	if(gameController.health == 0):
		gameController.health = 1

func setup():
	lastPosition = position
	addPlayerWeapon("res://scenes/weapons/pistol.tscn")
	gameController.health = 100
	gameController.canShoot = true
	get_parent().get_node("tint").visible = false
	dead = false
	
# reempezar nivel
func restartLevel(event):
	if(gameController.health < 0 and event.is_action_pressed("event_r")):
#		gameController.health = 100
#		gameController.canShoot = true
#		get_parent().get_node("tint").visible = false
		transition.reloadScene()
		
# pasar al siguiente nivel
func goToNextLevel(event):
	if(gameController.health >= 0 and event.is_action_pressed("event_r") and gameController.enemies <= 0):
		gameController.health = 100
		gameController.canShoot = true
		gameController.sceneToGoNumber += 1
		save.saveGame()
		gameController.secondLevelMusicWhenRestarted = 0
# El Timer es para que haga bien el difuminado y que despues cambie de nivel
		transition.changeScene("res://scenes/levels/intermission" + str(gameController.sceneToGoNumber) + ".tscn")

#func _on_entityEnabler_body_entered(body):
#	print(body.name)
#	body.set_physics_process(true)
##	body.set_process(true)
#
#
#func _on_entityEnabler_body_exited(body):
#	body.set_physics_process(false)
##	body.set_process(false)
