extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_play_pressed():
	transition.changeScene("res://scenes/levels/test/testLevel.tscn")

#func _on_play_pressed():
#	gameController.sceneToGoNumber = 1
#	var transition = load("res://scenes/effects/transition.tscn").instance()
#	transition.intro = false
#	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(transition)
#	get_parent().get_node("Timer").start()
#	yield(get_parent().get_node("Timer"), "timeout")
#	get_tree().change_scene("res://scenes/levels/intermission" + str(gameController.sceneToGoNumber) + ".tscn")
