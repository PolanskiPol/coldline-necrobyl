extends Node

var savePath
var saveFile
var loadResponse

# Called when the node enters the scene tree for the first time.
func _ready():
	savePath = {"sceneToGoNumber" : gameController.sceneToGoNumber}

func saveGame():
#	saveFile.set_value(section, key, value)
#	saveFile.save(savePath)
	savePath["sceneToGoNumber"] = gameController.sceneToGoNumber
	saveFile = File.new()
	saveFile.open("user://coldline.save", File.WRITE)
	saveFile.store_line(to_json(savePath))
	saveFile.close()
	
func loadGame():
#	gameController.sceneToGoNumber = saveFile.get_value(section, key, value)
	var saveFile = File.new()
	if(not saveFile.file_exists("user://coldline.save")):
        return # No savefile found
		
	saveFile.open("user://coldline.save", File.READ)
	
	var currentLine = parse_json(saveFile.get_line())
	print(currentLine["sceneToGoNumber"])
	# Firstly, we need to create the object and add it to the tree and set its position.
	gameController.sceneToGoNumber = currentLine["sceneToGoNumber"]
	
	saveFile.close()