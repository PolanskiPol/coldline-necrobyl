extends Node2D

var transiting
var transitingCounter

# Called when the node enters the scene tree for the first time.
# Efecto de transición al principio, y luego el texto sube.
func _ready():
	var transition = load("res://scenes/effects/transition.tscn").instance()
	transition.intro = false
	add_child(transition)
	transiting = false
	transitingCounter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	transitingCounter += delta
	if(transitingCounter >= 5):
		transiting = true
	
	if(transiting):
		position.y -= 1.25
		pass
