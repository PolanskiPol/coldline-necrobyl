extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	value = gameController.volume
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	configSave.saveConfig(OS.window_fullscreen, value)
