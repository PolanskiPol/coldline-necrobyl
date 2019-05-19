extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	save.loadGame()
	configSave.loadVolume()
	configSave.loadFullscreen()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), gameController.volume)
	OS.window_fullscreen = gameController.fullscreen
	$options/VBoxContainer/soundSlider.value = gameController.volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_settings_pressed():
	if($options.visible):
		$options.visible = false
	else:
		$options.visible = true
