extends Node

# este script actua como intermediario entre la UI, el jugador, las armas, los...
# ...enemigos y los niveles. cualquier valor que tenga que ser leido por dos o ...
# ...mas de los anteriores, se cambia aqui

var bullets = 0
var bulletsPerShot = 0
var accuracyAngle = 0
var damage = 0
var health = 100
var weaponPath = ""
var weaponName = ""
var canShoot = true
var zoomedOut = false
var currentLevelComplete = false
var enemies = 0
var secondLevelMusicWhenRestarted = 0.0
var sceneToGoNumber = 1

# config
var volume = 0
var fullscreen = false
var quality = ""
var vsync = true
var fps = 60
