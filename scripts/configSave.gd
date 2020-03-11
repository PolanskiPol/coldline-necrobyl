extends Node

var savePath
var saveFile
var loadResponse
var pseudo3DLayers
var advancedEnemyLights

# Called when the node enters the scene tree for the first time.
#Para que guarde configuración y cargue configuración
func _ready():
	savePath = "user://config.cfg"
	saveFile = ConfigFile.new()
	loadResponse = saveFile.load(savePath)
	pseudo3DLayers = 0
	advancedEnemyLights = false

func saveConfig(fullscreen, quality, volume, vsync, fps, pseudo3DLayers, advancedEnemyLights):
	saveFile.set_value("graphics", "fullscreen", fullscreen)
	saveFile.set_value("graphics", "quality", quality)
	saveFile.set_value("graphics", "pseudo3DLayers", pseudo3DLayers)
	saveFile.set_value("graphics", "advancedEnemyLights", advancedEnemyLights)
	
	saveFile.set_value("performance", "vsync", vsync)
	saveFile.set_value("performance", "fps", fps)
	
	saveFile.set_value("volume", "volume", volume)
	saveFile.save(savePath)

func loadConfig():
	OS.window_fullscreen = saveFile.get_value("graphics", "fullscreen", gameController.fullscreen)
#	gameController.quality = saveFile.get_value("graphics", "quality", gameController.quality)
	OS.vsync_enabled = saveFile.get_value("performance", "vsync", gameController.vsync)
	Engine.target_fps = saveFile.get_value("performance", "fps", gameController.fps)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), saveFile.get_value("volume", "volume", gameController.volume))
	pseudo3DLayers = saveFile.get_value("graphics", "pseudo3DLayers", pseudo3DLayers)
	advancedEnemyLights = saveFile.get_value("graphics", "advancedEnemyLights", advancedEnemyLights)
#	print(saveFile.get_value("graphics", "fullscreen", gameController.fullscreen))
#	print(saveFile.get_value("graphics", "quality", gameController.quality))
#	print(saveFile.get_value("performance", "vsync", gameController.vsync))
#	print(saveFile.get_value("performance", "fps", gameController.fps))
#	print(saveFile.get_value("volume", "volume", gameController.volume))
	
