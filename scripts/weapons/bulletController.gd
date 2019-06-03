extends Node2D

export var timeBeforeRemoving = 0.0
var timeCounter
var numberOfBullets
var bulletToInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	numberOfBullets = get_parent().get_node("player/weapon").bulletsPerShot
	timeCounter = 0
	addBullets()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	remove(delta)

func addBullets():
	var bullet = load("res://scenes/weapons/bullet.tscn")
	for i in range(0, numberOfBullets):
		var bulletInstance = bullet.instance()
		add_child(bulletInstance)
		bulletInstance.name = "bullet" + str(i)

func remove(delta):
	timeCounter += delta
	if(timeCounter >= timeBeforeRemoving):
		get_parent().remove_child(self)
