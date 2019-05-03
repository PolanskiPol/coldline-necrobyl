extends KinematicBody2D

export var speed = 4
export var animationSpeed = 200
var weapon = gameController.weapon
var lastPosition

func _ready():
	lastPosition = position
	addPlayerWeapon()
	

func _physics_process(delta):
	# detectamos los Input en cada frame, asi el jugador responde mas rapido
	# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
	movePlayer()
#	animate()
	# get_global_mouse_position() devuelve la posicion del raton en la pantalla
	look_at(get_global_mouse_position())
	playerDie()

# funcion para hacer los cambios de armas del jugador
func addPlayerWeapon():
	var instancedWeapon = load(weapon).instance()
	add_child(instancedWeapon)
	instancedWeapon.position = Vector2(5, 8)

# mueve al jugador con WASD
func movePlayer():
	if(Input.is_action_pressed("event_s")):
		move_and_collide(Vector2(0, speed))
	elif(Input.is_action_pressed("event_w")):
		move_and_collide(Vector2(0, -speed))
		
	if(Input.is_action_pressed("event_a")):
		move_and_collide(Vector2(-speed, 0))
	elif(Input.is_action_pressed("event_d")):
		move_and_collide(Vector2(speed, 0))

# cuando la vida del jugador es menor que 0, cambiamos la escena a "gameOver.tscn"
func playerDie():
	if(gameController.health < 0):
		get_tree().change_scene("res://scenes/menus/gameOver.tscn")