extends Node

var currentDialog
var maxDialogs

# Called when the node enters the scene tree for the first time.
func _ready():
	maxDialogs = get_child_count()
	currentDialog = 1
	get_node("dialog" + str(currentDialog)).visible = true

func _on_hide():
	if(currentDialog != maxDialogs):
		currentDialog += 1
		get_node("dialog" + str(currentDialog)).visible = true
	
	
