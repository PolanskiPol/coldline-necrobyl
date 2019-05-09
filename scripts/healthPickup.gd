extends Area2D

export var healthRestored = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# curar salud del jugador
func heal():
	gameController.health += 50
	if(gameController.health > 100):
		gameController.health = 100

# hacer cura al entrar en el area
func _on_healthPickup_body_entered(body):
	if(body.name == "player"):
		heal()
		get_parent().remove_child(self)
