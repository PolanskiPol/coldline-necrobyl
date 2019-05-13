extends Node2D

# script para preparar el nivel

export var startLevelMusicAt = 0.0
export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = false

func _ready():
	setupLevelMusic()
	gameController.enemies = 0
	gameController.currentLevelComplete = true

func setupLevelMusic():
	if(gameController.secondLevelMusicWhenRestarted == 0.0):
		$levelMusic.seek(startLevelMusicAt)
	else:
		$levelMusic.seek(gameController.secondLevelMusicWhenRestarted)