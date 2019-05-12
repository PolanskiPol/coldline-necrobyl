extends Node2D

# script para preparar el nivel

export var startLevelMusicAt = 0.0
export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = false

func _ready():
	setupLevelMusic()
	gameController.enemies = $enemies.get_child_count()
	setupTint()
	
func _process(delta):
	gameController.secondLevelMusicWhenRestarted = $levelMusic.get_playback_position()

func setupLevelMusic():
	if(gameController.secondLevelMusicWhenRestarted == 0.0):
		$levelMusic.seek(startLevelMusicAt)
	else:
		$levelMusic.seek(gameController.secondLevelMusicWhenRestarted)

# prepara el "tint" que oscurece la escena al entrar en lugares cerrados
func setupTint():
	$tint.color = tint
	if(startEnabled):
		$tint.color = tint
	else:
		$tint.color = Color(1, 1, 1)

# funcion para terminar el nivel
func completeLevel():
	if(gameController.enemies <= 0):
		gameController.currentLevelComplete = true
