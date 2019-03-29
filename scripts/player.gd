extends KinematicBody2D

export var speed = 4

#func _ready():
#	pass

func _physics_process(delta):
	# detectamos los Input en cada frame, asi el jugador responde mas rapido
	# dependiendo del Input (tecla), movemos el jugador con un Vector2(x, y) distinto
	if(Input.is_action_pressed("ui_down")):
		move_and_collide(Vector2(0, speed))
	elif(Input.is_action_pressed("ui_up")):
		move_and_collide(Vector2(0, -speed))
		
	if(Input.is_action_pressed("ui_left")):
		move_and_collide(Vector2(-speed, 0))
	elif(Input.is_action_pressed("ui_right")):
		move_and_collide(Vector2(speed, 0))
	
	# get_global_mouse_position() devuelve la posicion del raton en la pantalla
	$spriteJugador.look_at(get_global_mouse_position())
	
func _input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		# indicamos que escena se va a instanciar (la bala en este caso)
		var bullet = load("res://scenes/beta/bullet.tscn")
		# instanciamos la escena (la bala)
		var bulletInstance = bullet.instance()
		# metemos la escena instanciada (la bala) en la escena actual (el nivel en el que estamos)
		get_parent().add_child(bulletInstance)
		