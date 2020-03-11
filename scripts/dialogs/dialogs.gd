extends Node

# este script maneja las cajas de dialogo, ocultandolas o mostrandolas

var currentDialog
var totalDialogs

# Called when the node enters the scene tree for the first time.
func _ready():
	totalDialogs = get_child_count()
	currentDialog = 1
	get_node("dialog" + str(currentDialog)).visible = true
	
# si aun hay cajas de dialogos sin leer, pasa a la siguiente
func _on_hide():
	if(currentDialog != totalDialogs):
		currentDialog += 1
		get_node("dialog" + str(currentDialog)).visible = true
		

	
	
