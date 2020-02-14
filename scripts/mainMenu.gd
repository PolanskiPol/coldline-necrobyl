extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# cargar pantalla completa
func _ready():
	transition.play(transition.TRANSITION_IN)
	$title.play("move")
