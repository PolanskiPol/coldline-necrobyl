extends KinematicBody2D

signal arrivedToLastPlayerPosition

const PATH_DIRECTIONS = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)]
const PATH_ROTATIONS = [0, 270, 180, 90]

export var followPlayerWhenDissapears = true
export (int, 0, 15000, 1) var health = 100.0
export (float, 0, 10, 0.1) var speed = 0.0
export (int, 0, 100, 1) var attackDamage = 0.0
export (float, 0.1, 3, 0.05) var timeBetweenAttacks = 0.0
export (int, 60, 180, 2) var angleOfVision = 88
export var melee = false
export var complexWallFollow = false
export var randomMovement = false

var followTarget
var attackTarget
var dead
var canAttack
var canDealDamage
var isSeeingPlayer
var isSeeingLastPlayerPosition
var lastPlayerPosition
var player
var pathDirection
var currentPath
var canMove
var pathDelayDB
var facingPlayer
var speedModifier
var stepsSinceOutOfWall
var counterRaycastToPlayer
var timeToLoseSight
var playerPosition
var space_state
var result

# Called when the node enters the scene tree for the first time.
func _ready():
#	setLightQuality()
	facingPlayer = false
	pathDelayDB = false
	canMove = true
	pathDirection = Vector2(1, 0)
	currentPath = 0
	player = get_parent().get_parent().get_node("player")
	dead = false
	canAttack = true
	canDealDamage = false
	# los zombies tienen dos sonidos que se eligen aleatoriamente
	$zombiesound.stream = randomZombieSound()
	isSeeingPlayer = false
	lastPlayerPosition = player.position
#	set_physics_process(false)
	speed *= 50
	speedModifier = 1
	stepsSinceOutOfWall = 0
	counterRaycastToPlayer = 0
	moveRandomly()
	timeToLoseSight = 0.5
	facingPlayer = true
	$AnimationPlayer.play("walking")	
	set_physics_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()
	raycastToPlayer(delta)
#	optimizedRaycastToPlayer()
	isFacingPlayer()
	attackRanged()
	
func move():
	if(canMove):
		if(followTarget and isSeeingPlayer and !followTarget.dead):
			moveToPlayer()
		else:
			followPath()
	
func followPath():
	path()
	move_and_slide(pathDirection*speed*0.2)

# funcion para detectar si hay una pared entre el jugador y el enemigo
func raycastToPlayer(delta):
	counterRaycastToPlayer += delta
	if(counterRaycastToPlayer >= timeToLoseSight):
		playerPosition = player.position
		space_state = get_world_2d().get_direct_space_state()
		result = space_state.intersect_ray(Vector2(position.x, position.y), Vector2(playerPosition.x, playerPosition.y), [self, get_parent().get_parent().get_node("tilesets/pseudo3DLayer0/tiles")]) 
		rayLogic()

func rayLogic():
	if(result.size()):
		counterRaycastToPlayer = 0
		timeToLoseSight = 0.5
		if(result.collider.name == "player" and gameController.health > 0 and facingPlayer):
			isSeeingPlayer = true
			$pathDelay.stop()
			canMove = true
			pathDelayDB = true
		elif(result.collider.collision_layer == 2):
			pass 
		else:
			pathDelay()
			isSeeingPlayer = false
	else:
		timeToLoseSight = 0.5

# moverse en direccion al jugador
func moveToPlayer():
	var positionToMove
	var intPosition = Vector2(int(position.x/2), int(position.y/2))
	var intLastPlayerPosition = Vector2(int(lastPlayerPosition.x/2), int(lastPlayerPosition.y/2))
	if(followTarget and !dead and isSeeingPlayer and !followTarget.dead):
#		$wallBetween.cast_to = (followTarget.position - position).normalized()
		rotation = (followTarget.position - position).angle()
		move_and_slide((followTarget.position - position).normalized()*speed*speedModifier)
		lastPlayerPosition = player.position
#
#	elif(!dead and !isSeeingPlayer and position != lastPlayerPosition):
#		$wallBetween.cast_to = (followTarget.position - position).normalized()
		

# cuando el zombie llega a 0 de vida, no desaparece. en su lugar, instanciamos...
# ... una textura de sangre, paramos el sonido, y le "congelamos" en el sitio
func dieWhen0Health():
	if(health <= 0 and !dead):
		var instancedBlood = load("res://scenes/effects/bloodEffect.tscn").instance()
		instancedBlood.position = position
#		CENSORED for Don Bosco
#		get_parent().get_parent().get_node("props").add_child(instancedBlood)
		$Sprite.visible = false
		instanceAmmo(33)
		remove_child($CollisionShape2D)
		remove_child($zombiesound)
		speed = 0
		dead = true
		gameController.enemies -= 1
		set_physics_process(false)
		queue_free()
		
func instanceAmmo(percentage):
	randomize()
	var rand = rand_range(0, 100)
	if(rand <= percentage):
		var instancedAmmo = load("res://scenes/props/ammoPickup.tscn").instance()
		instancedAmmo.position = position
		get_parent().get_parent().get_node("props").add_child(instancedAmmo)

# nos encontramos con algunos problemas para hacer que el sonido de ...
# ... del zombie fuera aleatorio, y esta es la solución que encontramos
# al concatenar "randomSound" en "load(...)" daba errores

func setLightQuality():
	$Sprite.modulate = Color(0.5, 1, 0.5)
	$Sprite.material = load("res://themes/brightenemy.tres")
	if(!configSave.advancedEnemyLights):
		$bright.enabled = false
		$bright.visible = false
	else:
		$bright.enabled = true
		$bright.visible = true
		

func randomZombieSound():
	randomize()
	var sound
	var randomSound = randi()%2
	if(randomSound == 1):
		sound = load("res://audio/fx/zombie1.wav")
	else:
		sound = load("res://audio/fx/zombie2.wav")
	# return de sound, que es el sonido cargado
	return sound

# esta funcion la utiliza la escena "bullet.tscn" para hacer daño con la colision
func damage(dmg):
	health -= dmg
	dieWhen0Health()
#	putBloodOnFloor()

func attack():
	if(melee):
		attackMelee()
	else:
		attackRanged()

# el zombie daña al jugador si este esta en su rango de ataque
func attackMelee():
	if(canAttack and !dead and melee):
#		$slashsound.play(0)
		$attack.play("melee")
		print("atakin")
		
func attackRanged():
	if(canAttack and !dead and isSeeingPlayer and !melee):
		waitBetweenAttacks(timeBetweenAttacks)
		var bullet = load("res://scenes/enemies/bulletEnemy.tscn").instance()
		bullet.position = position
		get_parent().add_child(bullet)
		bullet.selfEnemyPosition = position
#		bullet.speed = 22
		print("XXDDDDDXKDKKDKDKDKDKDKDKDKKDKDKD")

# esperar entre ataques
func waitBetweenAttacks(wait):
	canAttack = false
	$Timer.start()
	yield($Timer, "timeout")
	$Timer.wait_time = wait
	canAttack = true
	
func path():
	if(!randomMovement):
		if($pathRaycasts/right.is_colliding()):
			stepsSinceOutOfWall = 0
			
		if(($pathRaycasts/front.is_colliding()
		and $pathRaycasts/right.is_colliding())
		or $pathRaycasts/singleFront.is_colliding()):
			currentPath += 1
			if(currentPath > 3):
				currentPath = 0
				
		if(complexWallFollow):
			stepsSinceOutOfWall += 1
			if((!$pathRaycasts/right.is_colliding())
			and $pathRaycasts/outerBorder.is_colliding()
			and (stepsSinceOutOfWall > 15)):
				stepsSinceOutOfWall = 0
				currentPath -= 1
				if(currentPath < 0):
					currentPath = 3
				
		pathDirection = PATH_DIRECTIONS[currentPath]
		rotation_degrees = PATH_ROTATIONS[currentPath]

func pathDelay():
	if(pathDelayDB):
		randomize()
		pathDelayDB = false
		$pathDelay.wait_time = rand_range(2, 3.5)
		$pathDelay.start(0)
		canMove = false
		
func isFacingPlayer():
	if(player.position != lastPlayerPosition):
		var facingAngle = get_angle_to(get_parent().get_parent().get_node("player").position) * 180 / PI
		if(facingAngle < angleOfVision and facingAngle > -angleOfVision):
			facingPlayer = true
		else:
			facingPlayer = false
			
func moveRandomly():
	if(randomMovement):
		randomize()
		var dirX = 1
		var dirY = 1
		yield(get_tree().create_timer(randf()*1+1), "timeout")
		var randDirX = randi()%2
		var randDirY = randi()%2
		if(randDirX == 0):
			dirX = -1
		if(randDirY == 0):
			dirY = -1
		var randomX = randf()*1*dirX
		var randomY = randf()*1*dirY
		pathDirection = Vector2(randomX, randomY)
		rotate(atan2(randomX, randomY))
		randomize()
		yield(get_tree().create_timer(randf()*1.5), "timeout")
		pathDirection = Vector2(0, 0)
		randomize()
		yield(get_tree().create_timer(randf()*2+1), "timeout")
		moveRandomly()
		
func _on_pathDelay_timeout():
	canMove = true
	
# cuando el jugador entra en el rango de ataque, se vuelve el "followTarget"
func _on_vision_entered(body):
	if(body.name == "player" and !dead):
		followTarget = body
		
# cuando el jugador sale del rango de ataque ya no es el "followTarget"
func _on_vision_exited(body):
	if(body == followTarget and !dead):
		followTarget = null

# cuando el jugador entra en el rango de ataque, se vuelve el "attackTarget"
func _on_attack_entered(body):
	if(body.name == "player"):
		attackMelee()
		
func _on_attack_exited(body):
	if(body.name == "player"):
		$attack.stop(true)
		$attack.seek(0, true)
		
func _on_damage_entered(body):
	if(body.name == "player"):
		gameController.health -= attackDamage
