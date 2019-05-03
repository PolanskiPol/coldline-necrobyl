extends Node

# este script actua como intermediario entre la UI, el jugador, las armas, los...
# ...enemigos y los niveles. cualquier valor que tenga que ser leido por dos o ...
# ...mas de los anteriores, se cambia aqui

var bullets = 0
var health = 100
var weapon = "res://scenes/player/weapons/pistol.tscn"
var levelToGo
