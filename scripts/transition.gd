extends Control

export var intro = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.visible = true
	if(intro):
		transitionIntro()
	else:
		transitionOutro()
	
	removeOnEnd()
	
func transitionIntro():
	$Tween.interpolate_property($Panel, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	print("INTRO")

func transitionOutro():
	$Tween.interpolate_property($Panel, "modulate:a", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	print("NOINTRO")
	
func removeOnEnd():
	$Timer.start()
	yield($Timer, "timeout")
	get_parent().remove_child(self)