extends Control

#signal dialogOver
export (Texture) var characterToDisplay
#export (PackedScene) var nextDialog
export (Array, String) var dialogs
export var rotationSpeed = 0.002
export var maxRotation = 0.12
var maxDialogs
var currentDialog
var character
var dialogText
var rotationDirection
var rotater

# Called when the node enters the scene tree for the first time.
func _ready():
	rotater = 0.01
	rotationDirection = 1
	maxDialogs = dialogs.size() -1
	currentDialog = 0
	character = $PanelContainer/MarginContainer/HBoxContainer/MarginContainer/character
	dialogText = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/PanelContainer/text
	character.texture = characterToDisplay
	dialogText.text = dialogs[currentDialog]

func _physics_process(delta):
	rotateCharacter()

func _on_pressed():
	advanceDialog()
		
func advanceDialog():
	if(currentDialog < maxDialogs):
		currentDialog += 1
		dialogText.text = dialogs[currentDialog]
	else:
		visible = false
#		goToNextDialog()
		
#func goToNextDialog():
#	if(nextDialog != null):
#		var dialogInstance = nextDialog.instance()
#		get_parent().add_child(dialogInstance)
		
func rotateCharacter():
	if(character.get_rotation() > maxRotation or character.get_rotation() < -maxRotation):
		rotationDirection *= -1
	
	rotater += rotationSpeed*rotationDirection
	character.set_rotation(rotater)
