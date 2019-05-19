extends Node

var savePath
var saveFile
var loadResponse

# Called when the node enters the scene tree for the first time.
func _ready():
	savePath = "user://config.cfg"
	saveFile = ConfigFile.new()
	loadResponse = saveFile.load(savePath)

func saveConfig(screen, volume):
	saveFile.set_value("screen", "fullscreen", screen)
	saveFile.set_value("volume", "volume", volume)
	saveFile.save(savePath)
	
func loadFullscreen():
	gameController.fullscreen = saveFile.get_value("screen", "fullscreen", gameController.fullscreen)
	
func loadVolume():
	gameController.volume = saveFile.get_value("volume", "volume", gameController.volume)
	