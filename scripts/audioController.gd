extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
#	value es la posicion del slider del volumen
	value = gameController.volume
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# cada vez que tocamos el slider, cambia el volumen global del juego y
# lo guarda en "configSave"
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
#	configSave.saveConfig(OS.window_fullscreen, value)
