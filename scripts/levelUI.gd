extends Control

# la interfaz se actualiza con los cambios que ocurren en "gameController.gd"

var health
var ammo
var weapon
var pause
var enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	health = $playerUI/VBoxContainer/health
	ammo = $playerUI/VBoxContainer/HBoxContainer/ammo
	weapon = $playerUI/VBoxContainer/HBoxContainer/weapon
	pause = $pauseMenu
	enemies = $enemies/Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		pause()

func _process(delta):
	health.value = gameController.health
	weapon.text = "WEAPON: " + str(gameController.weaponName)
	ammoText()
	enemiesText()
	restartText()

# mostrar numero de balas
func ammoText():
	if(gameController.bullets < 0):
		ammo.text = "AMMO: INF"
	else:
		ammo.text = "AMMO: " + str(gameController.bullets)

# pausar el juego y mostrar interfaz
func pause():
	if(!pause.visible):
		pause.visible = true
		get_tree().paused = true
	else:
		pause.visible = false
		get_tree().paused = false

# mostrar texto cuando mueres
func restartText():
	if(gameController.health < 0):
		$restart.visible = true

# mostrar numero de enemigos vivos
func enemiesText():
	if(gameController.enemies > 0):
		enemies.text = "ENEMIES: " + str(gameController.enemies)
	else:
		enemies.text = "LEVEL COMPLETE"
		$nextLevel.visible = true