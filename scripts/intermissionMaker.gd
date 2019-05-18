extends Node2D

# script para preparar el nivel

export var startLevelMusicAt = 0.0
export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = false

func _ready():
	$tint.color = Color(1, 1, 1)
	setupLevelMusic()
	gameController.enemies = 0
	gameController.currentLevelComplete = true

func setupLevelMusic():
		$levelMusic.seek(startLevelMusicAt)

func _on_hide():
	pass # Replace with function body.
