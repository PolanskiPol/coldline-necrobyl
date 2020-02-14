extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_fullscreen_pressed():
	if(OS.window_fullscreen == false):
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
		
#	configSave.saveConfig(OS.window_fullscreen, get_parent().get_node("soundSlider").value)