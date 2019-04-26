extends KinematicBody2D

export var speed = 4
export var animationSpeed = 200
export(PackedScene) var weapon
var lastPosition

func _ready():
	lastPosition = position

func _physics_process(delta):
	# detectamos los Input en cada frame, asi el jugador responde mas rapido
	# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
	movePlayer()
#	animate()
	# get_global_mouse_position() devuelve la posicion del raton en la pantalla
	look_at(get_global_mouse_position())
	
func _input(event):
	shoot()

func movePlayer():
	if(Input.is_action_pressed("event_s")):
		move_and_collide(Vector2(0, speed))
	elif(Input.is_action_pressed("event_w")):
		move_and_collide(Vector2(0, -speed))
		
	if(Input.is_action_pressed("event_a")):
		move_and_collide(Vector2(-speed, 0))
	elif(Input.is_action_pressed("event_d")):
		move_and_collide(Vector2(speed, 0))
		
func shoot():
	if(Input.is_action_just_pressed("event_leftclick")):
		# indicamos que escena se va a instanciar (la bala en este caso)
		var bullet = load("res://scenes/beta/bullet.tscn")
		# instanciamos la escena (la bala)
		var bulletInstance = bullet.instance()
		# metemos la escena instanciada (la bala) en la escena actual (el nivel en el que estamos)
		get_parent().add_child(bulletInstance)