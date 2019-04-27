extends Node2D

export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = false
#export(AudioStreamSample) var levelMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	setupTint()

func setupTint():
	$tint.color = tint
	if(startEnabled):
		$tint.color = tint
	else:
		$tint.color = Color(1, 1, 1)
		print($tint.color)
	
