extends Node2D

# script para preparar el nivel

export var startLevelMusicAt = 0.0
export(Color) var tint = Color(0.13, 0.13, 0.13)
export var startEnabled = false

func _ready():
	gameController.enemies
	setupLevelMusic()
	gameController.enemies = $enemies.get_child_count()
	transition.play(transition.TRANSITION_IN)
	setupTint()
	
func _input(event):
	if(event.is_action_pressed("ui_accept")):
		enterActionMusic()
	elif(event.is_action_pressed("devkey")):
		enterExploreMusic()
	
func _physics_process(delta):
	gameController.secondLevelMusicWhenRestarted = $levelMusicAction.get_playback_position()

# TODO: remake this function with the new music structure (2 tracks)
func setupLevelMusic():
	if(gameController.secondLevelMusicWhenRestarted == 0.0):
		$levelMusicAction.seek(startLevelMusicAt)
	else:
		$levelMusicAction.seek(gameController.secondLevelMusicWhenRestarted)

# prepara el "tint" que oscurece la escena al entrar en lugares cerrados
func setupTint():
	$tint.visible = true
	$tint.color = tint
	if(startEnabled):
		$tint.color = tint
	else:
		$tint.color = Color(1, 1, 1)

# funcion para terminar el nivel
func completeLevel():
	if(gameController.enemies <= 0):
		gameController.currentLevelComplete = true
		
func changeExploreMusicTo(newTrack):
	$levelMusicExplore.stream = newTrack
	
func changeActionMusicTo(newTrack):
	$levelMusicExplore.stream = newTrack
	
func enterActionMusic():
	$musicAnimations.play("actionToExplore")
	
func enterExploreMusic():
	$musicAnimations.play("exploreToAction")
	
