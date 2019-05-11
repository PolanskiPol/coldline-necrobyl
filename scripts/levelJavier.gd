extends Node2D

# script para preparar el nivel

export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = true

func _ready():
	setupTint()

func setupTint():
	$tint.color = tint
	if(startEnabled):
		$tint.color = tint
	else:
		$tint.color = Color(1, 1, 1)

