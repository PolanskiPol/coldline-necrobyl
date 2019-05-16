extends Node

var savePath
var saveFile
var loadResponse

# Called when the node enters the scene tree for the first time.
func _ready():
	savePath = "res://saves/savefile.cfg"
	saveFile = ConfigFile.new()
	loadResponse = saveFile.load(savePath)

func saveGame(section, key, value):
	saveFile.set_value(section, key, value)
	saveFile.save(savePath)
	
func loadGame(section, key, value):
	gameController.sceneToGoNumber = saveFile.get_value(section, key, value)