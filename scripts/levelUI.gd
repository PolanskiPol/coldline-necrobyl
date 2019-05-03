extends Control

# la interfaz se actualiza con los cambios que ocurren en "gameController.gd"

var health
var ammo
var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	health = $MarginContainer/VBoxContainer/health
	ammo = $MarginContainer/VBoxContainer/HBoxContainer/ammo
	weapon = $MarginContainer/VBoxContainer/HBoxContainer/weapon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health.value = gameController.health
	weapon.text = "Weapon: " + str(gameController.weapon)
	ammoText()
	
func ammoText():
	if(gameController.bullets < 0):
		ammo.text = "Ammo: inf"
	else:
		ammo.text = "Ammo: " + str(gameController.bullets)
