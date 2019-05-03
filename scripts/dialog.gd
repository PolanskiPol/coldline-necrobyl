extends Control

# este script es la base para los dialogos en si
# los dialogos funcionan con este script y con "dialogs.gd"
# "dialogs.gd" es el encargado de manejar todas las cajas de dialogo

# textura para el personaje que habla
export (Texture) var characterToDisplay
# array de strings con los dialogos
export (Array, String) var dialogs
# decoracion
export var rotationSpeed = 0.002
export var maxRotation = 0.12
# nº total de dialogos
var totalDialogs
# dialogo activo
var currentDialog
var character
var dialogText
var rotationDirection
var rotater

# Called when the node enters the scene tree for the first time.
func _ready():
	rotater = 0.01
	rotationDirection = 1
	totalDialogs = dialogs.size() -1
	currentDialog = 0
	character = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/character
	dialogText = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/text
	character.texture = characterToDisplay
	dialogText.text = dialogs[currentDialog]

func _physics_process(delta):
	rotateCharacter()

func _on_pressed():
	advanceDialog()

# funcion para cambiar el texto del dialogo
func advanceDialog():
	if(currentDialog < totalDialogs):
		currentDialog += 1
		dialogText.text = dialogs[currentDialog]
	else:
		visible = false

# funcion para rotar la foto del personaje que habla
func rotateCharacter():
	if(character.get_rotation() > maxRotation or character.get_rotation() < -maxRotation):
		rotationDirection *= -1
	
	rotater += rotationSpeed*rotationDirection
	character.set_rotation(rotater)
